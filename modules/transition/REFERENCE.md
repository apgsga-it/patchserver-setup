# Reference
<!-- DO NOT EDIT: This document was generated by Puppet Strings -->

## Table of Contents

**Resource types**

* [`transition`](#transition): Define a transitional state.

## Resource types

### transition

Define a transitional state.

#### Properties

The following properties are available in the `transition` type.

##### `enable`

Valid values: `true`, `false`

Enable or disable this conditional state transition. Valid values
are true or false.

Default value: true

#### Parameters

The following parameters are available in the `transition` type.

##### `resource`

The resource for which a transitional state is being defined. This
should be a resource reference (e.g. Service['apache']). This resource
will be made to autorequire the transitional state.

##### `attributes`

The hash of attributes to set on the resource when applying a
transitional state. Each hash key must be a valid attribute for the
resource being transitioned.

##### `prior_to`

An array of resources to check for synchronization. If any of these
resources are out of sync (change pending), then this transitional state
will be applied. These resources will each be made to autorequire the
transitional state.

##### `name`

namevar

This parameter does not serve any function beyond setting the
resource's name.
