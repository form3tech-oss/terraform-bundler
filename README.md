# Terraform Bundle Container
This container is responsible for building a [Terraform Bundle](https://github.com/hashicorp/terraform/tree/master/tools/terraform-bundle), which
is a custom terraform binary which contains the providers we need on a day to day basis.

To update a version for a given provider or add a new one, edit the version in the `form3-bundle.json` file. The file is in JSON
format, and each provider should have a `name`, `version` and `url` properties.
The value of the `version` field **MUST** correspond to an existing tag.
Once you have made your changes, raise a PR, get
it approved and once it's merged, it will trigger a Travis build which will generate the bundle, publish the generated ZIP file in Github as a Release 
and call TFE's REST api so that the new bundle is installed automatically. You'll have to update the Terraform
version used by the workspaces in TFE.

## Binaries must be statically linked
For the provider binaries to work with Terraform, they need to be statically linked when build, see issue [https://github.com/terraform-providers/terraform-provider-helm/pull/111#issue-215953125](https://github.com/terraform-providers/terraform-provider-helm/pull/111#issue-215953125). Basically, if you're building Go binaries, use `CGO_ENABLED=0` when building.

