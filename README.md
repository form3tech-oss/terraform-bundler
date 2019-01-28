# Terraform Bundle Container
This container is responsible for building a [Terraform Bundle](https://github.com/hashicorp/terraform/tree/master/tools/terraform-bundle), which
is a custom terraform binary which contains the providers we need on a day to day basis.

To update a version for a given provider, edit the version in the `.env` file.

When running the container, a bundle will be generated on the `/output` container directory, so a volume should be mounted on that
directory to retrieve the generated ZIP file.

The scripts that run as part of the build will generate the bundle, publish the generated ZIP file in Github as a Release 
and call TFE's REST api so that the new bundle is installed automatically.
