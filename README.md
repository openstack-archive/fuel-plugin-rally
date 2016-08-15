Openstack Rally plugin
=======================

Provides a separate role for deployment of the Rally benchmarking tool

Building the plugin
-------------------

1. Clone the fuel-plugin repo:

    ``git clone https://review.openstack.org/openstack/fuel-plugin-rally``

2. Install the Fuel Plugin Builder:

    ``pip install fuel-plugin-builder``

3. Build Rally Fuel plugin:

    ``fpb --build fuel-plugin-rally/``

4. The fuel-plugin-rally-<x.x.x>.rpm plugin package will be created in the plugin folder
   (uel-plugin-rally/).

5. Move this file to the Fuel Master node with secure copy (scp):

    ``scp fuel-plugin-rally/fuel-plugin-rally-<x.x.x>.rpm root@:<the_Fuel_Master_node_IP address>:/tmp``  
    ``ssh root@:<the_Fuel_Master_node_IP address>``  
    ``cd /tmp``

6. Install the Ceilometer Rallyre plugin:

    ``fuel plugins --install fuel-plugin-rally-<x.x.x>.rpm``

7. Plugin is ready to be used and can be enabled on the Settings tab of the Fuel web UI.

