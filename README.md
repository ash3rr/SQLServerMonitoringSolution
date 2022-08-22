# SQL Server Monitoring Solution

The solution is comprised of  *.tbl files which must be installed ran first inside the DBATools database.

After this you can create the stored procedure files (sp_) in the same database. 

You should then create the jobs.

After this installation step, metrics are inserted into tables within the DBATools database. The Power BI dashboard which is in the repository connects to and allows you
visualise these metrics in order to monitor SQL Server performance.

