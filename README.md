# PCDB

This project collects the TeX-files, SQL-scripts and all other pieces necessary to maintain the Political Configuration Database (PCDB) on the HU-Server, to compile the Codebook and the Documentation.

## Coodebook

The Codebook provides an overview over the Tables and Views in the PCDB. File 'PCDB_codebook_header.tex' defines the global settings, and inputs file 'PCDB_codebook_structure.tex', which in turn organizes the Codebook chapters ('chap_*.tex'), sections ('sec_*.tex'), and subsection ('chap_*.tex'). Tables are inputed in section from TeX-files with prefix 'tab_'.

## Documentation

The Documentation provides a guide of how to access the PCDB on the HU-Server, how to query data using pgAdmin3, and extensive description on how data in the PCDB is defined and structured, and how tables, views, functions, triggers, etc. are defined.

File 'PCDB_documentation_header.tex' defines the global settings, and inputs file 'PCDB_documentation_structure.tex', which in turn organizes the Documentation chapters ('chap_*.tex'), sections ('sec_*.tex'), and subsection ('chap_*.tex'). Tables are inputed in section from TeX-files with prefix 'tab_'. SQL-code-snippets are inputed with the 'listings' package, using relative paths to the SQL-Codes folder.

## SQL-Code

The folder 'SQL-Codes' documents the data definition language (DDL) scripts for all tables, view, functions, and triggers, in the PCDB.

## PCDB beta-version

The folder 'beta_version' is a field of experimentation, assembling SQL-scripts that have not yet been applied to the PCDB 'config_data' schema.

