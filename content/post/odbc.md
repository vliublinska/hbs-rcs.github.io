---
title: MariaDB, Stata, ODBC, and Mac OS X
author: Andrew Marder
date: 2017-08-17
tags:
  - grid
slug: mariadb
---

This guide will walk you through how to set up ODBC on a Mac to get data from the MariaDB server into Stata. Please feel free to write in the comments if you're having any issues.

1.  Install iODBC. Although Mac OS X comes with iODBC, it is not fully featured and may be out of date. I installed iODBC using the "mxkozzzz.dmg" file from the [downloads page](http://www.iodbc.org/dataspace/doc/iodbc/wiki/iodbcWiki/Downloads).

2.  Install the [MySQL ODBC Connector](https://dev.mysql.com/downloads/connector/odbc/). I installed the ODBC drivers using the DMG archive. On the download page there is a link "no thanks, just start my download" so you don't need to provide any contact information.

3.  Open the "iODBC Data Source Administrator64" application.

    1.  Initialize a new "User DSN" by clicking the "Add" button.
    2.  Select the "MySQL ODBC 5.3 Unicode Driver", click finish.
    3.  Specify a "Data Source Name (DSN)". For this walk through I'll call mine "mydsn".
    4.  Add the following key-value pairs using the "+" button:
    
        ```ini
        server   = rhrcssql01.hbs.edu
        database = as_cortellis
        user     = amarder
        password = XXXXX
        ```
        
        Be sure to fill in the appropriate database, user, and password values.
        
    5.  Press Ok.
    
4.  To make sure that your DSN is working, highlight your newly created user data source, press the "Test" button, and enter your user name and password. You should see the message "the connection DSN was tested successfully, and can be used at this time."
    
5.  Open Stata and issue the following commands:

    ```stata
    set odbcdriver ansi
    odbc list
    odbc load , exec("SELECT * FROM mytable") dsn("mydsn")
    ```
    
    Be sure to fill in appropriate "mytable" and "mydsn" values.
    
Final note, if you are connecting to the MariaDB server from off campus you need to connect to the VPN first.
    

## References

I found [this post from Stata](http://www.stata.com/support/faqs/data-management/configuring-odbc/) helpful.

I also found [this post from MySQL](https://dev.mysql.com/doc/connector-odbc/en/connector-odbc-installation-binary-osx.html) helpful.

[This post from MariaDB](https://mariadb.com/kb/en/mariadb/mariadb-vs-mysql-compatibility/) explains why I decided to use the MySQL ODBC Connector (it's compatible and it's "easy" to install).
