[Cmdletbinding()]
Param(
    [string]$ClientID = (Get-Content ".env" | Out-String | ConvertFrom-StringData).AZURE_B2C_CLIENT_ID,
    [string]$ClientSecret = (Get-Content ".env" | Out-String | ConvertFrom-StringData).AZURE_B2C_CLIENT_SECRET,
    [string]$TenantId = (Get-Content ".env" | Out-String | ConvertFrom-StringData).AZURE_B2C_TENANT_ID,
    [string]$Folder = "./dist/custom-policies/",
    [string]$Files = (Get-ChildItem "dist/custom-policies" | ForEach-Object { $_.name }) -join ',',
    [string]$TenantName = (Get-Content ".env" | Out-String | ConvertFrom-StringData).AZURE_B2C_DOMAIN
)

try {
    $body = @{grant_type = "client_credentials"; scope = "https://graph.microsoft.com/.default"; client_id = $ClientID; client_secret = $ClientSecret }

    $response = Invoke-RestMethod -Uri https://login.microsoftonline.com/$TenantId/oauth2/v2.0/token -Method Post -Body $body
    $token = $response.access_token

    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("Content-Type", 'application/xml')
    $headers.Add("Authorization", 'Bearer ' + $token)

    # Get the list of files to upload
    $filesArray = $Files.Split(",")

    Foreach ($file in $filesArray) {

        $filePath = $Folder + $file.Trim()

        # Check if file exists
        $FileExists = Test-Path -Path $filePath -PathType Leaf

        if ($FileExists) {
            $policycontent = Get-Content $filePath -Encoding UTF8

            # Optional: Change the content of the policy. For example, replace the tenant-name with your tenant name.
            $policycontent = $policycontent.Replace("your-tenant.onmicrosoft.com", "$TenantName")


            # Get the policy name from the XML document
            $match = Select-String -InputObject $policycontent  -Pattern '(?<=\bPolicyId=")[^"]*'

            If ($match.matches.groups.count -ge 1) {
                $PolicyId = $match.matches.groups[0].value

                Write-Output "Uploading the $PolicyId policy..."

                $graphuri = 'https://graph.microsoft.com/beta/trustframework/policies/' + $PolicyId + '/$value'
                $content = [System.Text.Encoding]::UTF8.GetBytes($policycontent)
                $response = Invoke-RestMethod -Uri $graphuri -Method Put -Body $content -Headers $headers -ContentType "application/xml; charset=utf-8"

                Write-Output "Policy $PolicyId uploaded successfully."
            }
        }
        else {
            $warning = "File " + $filePath + " couldn't be not found."
            Write-Warning -Message $warning
        }
    }
}
catch {
    Write-Output "StatusCode:" $_.Exception.Response.StatusCode.value__

    $_

    $streamReader = [System.IO.StreamReader]::new($_.Exception.Response.GetResponseStream())
    $streamReader.BaseStream.Position = 0
    $streamReader.DiscardBufferedData()
    $errResp = $streamReader.ReadToEnd()
    $streamReader.Close()

    $ErrResp

    exit 1
}

exit 0