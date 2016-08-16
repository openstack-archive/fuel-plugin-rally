.. _user_guide:

User Guide
==========

.. _plugin_configuration:

Plugin configuration
--------------------

To configure your plugin, you need to follow these steps:

1. `Create a new environment <http://docs.mirantis.com/openstack/fuel/fuel-7.0/user-guide.html#launch-wizard-to-create-new-environment>`_
   with the Fuel web user interface.

#. Click on the Settings tab of the Fuel web UI.

#. Selecto Other item on the left menu and find Rally plugins listing.

4. Select the Rally Plugin checkbox and fill-in the required fields.

  a. If official repository is used - select master or tag version.
  b. If developer repository is used - type valid repository url and proper tag version

5. Assign the *Rally* role to a new node.

6. `Configure your environment <http://docs.mirantis.com/openstack/fuel/fuel-7.0/user-guide.html#configure-your-environment>`_
   as needed.

#. `Verify the networks <http://docs.mirantis.com/openstack/fuel/fuel-7.0/user-guide.html#verify-networks>`_ on the Networks tab of the Fuel web UI.

#. `Deploy <http://docs.mirantis.com/openstack/fuel/fuel-7.0/user-guide.html#deploy-changes>`_ your changes.

.. _plugin_install_verification:

Plugin verification
-------------------

Be aware, that depending on the number of nodes and deployment setup,
deploying a Mirantis OpenStack environment can typically take anything
from 30 minutes to several hours.

**Rally**

Once your deployment has completed, you should verify that Rally is
installed properly by logging into Rally node and executing ::

    rally deployment check existing

The expected output should look like something like this::

    keystone endpoints are valid and following services are available:
    +-------------+----------------+-----------+
    | services    | type           | status    |
    +-------------+----------------+-----------+
    | __unknown__ | artifact       | Available |
    | __unknown__ | computev3      | Available |
    | __unknown__ | volumev2       | Available |
    | __unknown__ | volumev3       | Available |
    | cinder      | volume         | Available |
    | cloud       | cloudformation | Available |
    | glance      | image          | Available |
    | heat        | orchestration  | Available |
    | keystone    | identity       | Available |
    | neutron     | network        | Available |
    | nova        | compute        | Available |
    | s3          | s3             | Available |
    | swift       | object-store   | Available |
    +-------------+----------------+-----------+

**Note:** You can retrieve the IP address where Rally is installed using
the `fuel` command line::

    [root@fuel ~]# fuel nodes
      id | status | name       | cluster | ip          | mac               | roles      | pending_roles | online | group_id
      ---|--------|------------|---------|-------------|-------------------|------------|---------------|--------|---------
      9  | ready  | rally      | 2       | 10.109.10.5 | 2e:2d:42:5e:a0:54 | rally      |               | True   | 2       
      8  | ready  | compute    | 2       | 10.109.10.7 | 64:3f:1a:41:a6:c4 | compute    |               | True   | 2       
      7  | ready  | controller | 2       | 10.109.10.6 | 62:04:8f:5a:69:f9 | controller |               | True   | 2  