# GitHub Action for Deploying Azure AD B2C custom policies

This is a fork of the [azure-ad-b2c/deploy-trustframework-policy](https://github.com/azure-ad-b2c/deploy-trustframework-policy) repository to convert it into a PowerShell-based composite action to account for better error handling.

Use this GitHub Action to deploy an [Azure AD B2C custom policy](https://docs.microsoft.com/azure/active-directory-b2c/custom-policy-overview) into your Azure Active Directory B2C tenant using the [Microsoft Graph API](https://docs.microsoft.com/graph/api/resources/trustframeworkpolicy?view=graph-rest-beta). If the policy does not yet exist, it will be created. If the policy already exists, it will be replaced.

For more information, see [Deploy Azure AD B2C custom policy with GitHub actions](https://docs.microsoft.com/azure/active-directory-b2c/deploy-custom-policies-github-action).

## Getting Started

```bash
git clone https://github.com/Andrews-McMeel-Universal/deploy-trustframework-policy
```

### Inputs

| Variable             | Description                                                                                                 | Required | `[Default]` |
| -------------------- | ----------------------------------------------------------------------------------------------------------- | :------: | ----------- |
| `folder`             | The folder where the custom policies files are stored                                                       |    x     | `N/A`       |
| `files`              | Comma delimiter list of policy files                                                                        |    x     | `N/A`       |
| `tenant`             | The full Azure AD B2C tenant name (for example, contoso.onmicrosoft.com) or GUID                            |    x     | `N/A`       |
| `clientId`           | The application Client ID for a service principal which will be used to authenticate to the Microsoft Graph |    x     | `N/A`       |
| `clientSecret`       | The application Secret for a service principal which will be used to authenticate to the Microsoft Graph    |    x     | `N/A`       |
| `renumberSteps`      | Renumber the orchestration steps. Possible values: true, or false                                           |          | `false`     |
| `addAppInsightsStep` | Add App Insights orchestration steps to the the user journeys.                                              |          | `false`     |
| `verbose`            | Log level verbose.                                                                                          |          | `false`     |

### Sample workflow

```yaml
on: push

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Upload TrustFrameworkBase Policy
        uses: azure-ad-b2c/deploy-trustframework-policy@v5
        with:
          folder: "./Policies"
          files: "TrustFrameworkBase.xml,TrustFrameworkExtensions.xml,SignUpOrSignin.xml"
          tenant: my-tenant.onmicrosoft.com
          clientId: 00000000-0000-0000-0000-000000000000
          clientSecret: ${{ secrets.clientSecret }}
          renumberSteps: false
```

---

## Reusable Workflow Integration

Once a pull request is merged into _main_, you can create a new release to use it as a reusable workflow. To create a new release, follow the instructions in this guide: [Creating a Release](https://amuniversal.atlassian.net/wiki/spaces/TD/pages/3452043300/Creating+a+new+GitHub+Release#Creating-a-release)

### Update Major Release

Once you've created a new release, you can use the [Update Major Release Workflow](https://github.com/Andrews-McMeel-Universal/deploy-trustframework-policy/actions/workflows/update-major-release.yaml) to automatically update the major release tag for the repository.

1. Navigate to the [Update Major Release](https://github.com/Andrews-McMeel-Universal/deploy-trustframework-policy/actions/workflows/update-major-release.yaml) workflow.
1. Press "Run workflow" on the right-hand side of the page.
1. Specify the tag to create a major release for and what the major release will be.
1. Click "Run workflow"
