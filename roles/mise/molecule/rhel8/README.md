# molecule default-vmware configuration

\[\[_TOC_\]\]

## Usage

Install this to the molecule directory for any role.

The final path should be <collection path>/roles/<role>/molecule/default
Edit converge.yml and  replace aide_NAME with the name of the role

To use for other scenarios change the name to the name of the new scenario and replace
"defaut" in molecule.yml wherever it occurs to the name of the new scenario

## Requirements

The molecule.yml file expects an inventory to exist at
"${MOLECULE_PROJECT_DIRECTORY}/../../tests/default/inventory.yml"

This path points to the tests directory in the root of the
collection. In this way, the same inventory can be used
to test multiple roles

Create the inventory with hosts that match the platform names, or change the path.

See any the nats.default collection for examples

## Tests

A Testinfra test file example is located in the tests folder, modify it for
your use-cases.

## Vars

The vsphere configuration is in the molecule.yml as well in the `vars.yml` file.
Edit these files as necessary.

For more information see the
[molecule docs](https://molecule.readthedocs.io/en/latest/)

## SSH

The molecule.yml references an ssh key (bean_ssh_key) and an ssh config file
(config) for ssh connections to the VMs in the root of the collection,
provide these files or update the paths as necessary.

## Author Information

[NATS](mailto:agency-dl-cp-systems@mail.nasa.gov)
