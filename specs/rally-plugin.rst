..
 This work is licensed under a Creative Commons Attribution 3.0 Unported
 License.

http://creativecommons.org/licenses/by/3.0/legalcode

===============================================
Fuel plugin to install Rally
===============================================

# blueprint link

Rally is a benchmarking tool that answers the question: “How does OpenStack work at scale?”. To make this possible, Rally automates and unifies multi-node OpenStack deployment, cloud verification, benchmarking & profiling.

Problem description
===================

A QA engineer needs to verfy OpenStack cloud state, benchmark and profile existing infrastracture with Rally

Proposed change
===============

Rally plugin provides separate Fuel role for deploying Rally node in cluster with out-of-box ready for use Rally tool.

Alternatives
------------

* Rally can be installed manually, but this requires:

  - configuration with proper networks

  - system dependency resolution

  - deployment configuration with proper credentials


Data model impact
-----------------

None

REST API impact
---------------

None

Upgrade impact
--------------

None

Security impact
---------------

None

Notifications impact
--------------------

None

Other end user impact
---------------------

None

Performance Impact
------------------

None

Other deployer impact
---------------------

Rally plugin requires separate node without any other roles

Developer impact
----------------

None

Implementation
==============

Assignee(s)
-----------

Volodymyr Stoiko <vstoiko@mirantis.com> (developer)
Sergey Kulikov  <skulikov@mirantis.com> (developer)


Work Items
----------

* Implement the Rally plugin.

* Implement the Puppet manifests.

* Testing.

* Write the documentation.

Dependencies
============

* Fuel 7.0 and higher.

* It will be installed in an empty role.


References
==========

.. [#] https://wiki.openstack.org/wiki/Rally
