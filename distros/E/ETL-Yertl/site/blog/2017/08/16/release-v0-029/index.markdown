---
tags: release
title: Release v0.029
---

In this release:

## Added

* yq's filter language now allows `$.` to refer to the initial document
  even if the current document (`.`) is something else. This way one can
  traverse the document using `|` filters and still get to the original.
* yq's filter language now allows assigning values to filters, so you
  can modify documents in-place.
* yq's filter language now has an `each()` function to iterate over
  hashes/arrays
* yq's filter language now allows function calls on either side of
  binary operators (assignment operator and comparison operators). This
  means we can filter based on the output of a function (like find all
  arrays with more than 5 elements) or assign the output of a function
  to a place in the document (like replace an array with its length).

## Fixed

* We now give better error messages when accidentally trying to insert
  hashrefs or arrayrefs into a column using the `ysql` `--insert`
  helper. SQL::Abstract does not allow this and instead gives an
  untrappable warning (instead of throwing an exception, which is
  potentially earmarked for SQL::Abstract v2)

[More information on ETL::Yertl 0.029 on MetaCPAN](https://metacpan.org/release/PREACTION/ETL-Yertl-0.029)
