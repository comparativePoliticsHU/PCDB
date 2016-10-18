# PCDB

This project repository collects the TeX-files, SQL-scripts and all other pieces necessary to maintain the Political Configuration Database (PCDB) on the HU-Server, and to compile the Codebook and the Documentation.

## Coodebook

The Codebook provides an overview over the Tables and Views in the PCDB. File 'PCDB\_codebook\_header.tex' defines the global settings, and inputs file 'PCDB\_codebook\_structure.tex', which in turn organizes the Codebook chapters ('chap\_\*.tex'), sections ('sec\_\*.tex'), and subsection ('chap\_\*.tex'). Tables are inputed in section from TeX-files with prefix 'tab\_'.

## Documentation

The Documentation provides a guide of 

* how to access the PCDB on the HU-Server, 
* how to query data using SQL in pgAdmin,  
* extensive description of how entities in the PCDB are set into relation defined and structured, and 
* how tables, views, functions, and triggers are defined.

The Documentation is wirtten in TeX, and all files required to compile the document are found in the 'Documentation/' directory.

File 'PCDB\_documentation\_header.tex' defines the global settings, and inputs file 'PCDB\_documentation\_structure.tex', which in turn organizes the Documentation chapters ('chap\_\*.tex'), sections ('sec\_\*.tex'), and subsection ('chap\_\*.tex'). 

Chapters, sections and subsections are grouped in correspodnign subdirectories of the Documentation folder, namely 'chaps/', 'secs/' and 'subsecs/'.
Screenshots, used to illustrate how to work in pgAdmin, are collected in 'pcdb_documentation_screenshots/'; and Figures like flow charts and entity-relationship (ER) diagrams can be found in the 'graphics/' subdirectory. 

SQL code-snippets are inputed with the 'listings' package, using relative paths to the SQL-Codes folder.

## SQL-Code

The folder 'SQL-Codes/' documents the data definition language (DDL) scripts for all tables, views, functions and triggers, in the PCDB.

## PCDB beta-version

The folder 'beta_version' is a field of experimentation, assembling SQL-scripts that have not yet been applied to the PCDB 'config_data' schema.

