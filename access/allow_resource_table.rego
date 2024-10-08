package access
import data.abac_am
import data.utils
import future.keywords.every
import future.keywords.if
import future.keywords.in

allow_for_resource_table(operation, resource) if {
    operation == "SelectFromColumns"
    catalog_name := resource.table.catalogName
    schema_name := resource.table.schemaName
    table_name := resource.table.tableName
    table_obj := abac_am.table_attributes(catalog_name, schema_name, table_name)
    every column_name in resource.table.columns {
		utils.user_can_access_column(utils.user_id, catalog_name, schema_name, table_obj, column_name)
	}
}

allow_for_resource_table(operation, resource) if {
    operation == "FilterTables"
    catalog_name := resource.table.catalogName
    schema_name := resource.table.schemaName
    table_name := resource.table.tableName
    utils.user_can_access_table(utils.user_id, catalog_name, schema_name, table_name)
}

allow_for_resource_table(operation, resource) if { 
    operation == "ShowColumns"
    catalog_name := resource.table.catalogName
    schema_name := resource.table.schemaName
    table_name := resource.table.tableName
    utils.user_can_access_table(utils.user_id, catalog_name, schema_name, table_name)
}

# this operation is on table resource but it is actually a column operation
allow_for_resource_table(operation, resource) if {
	operation == "FilterColumns"
    catalog_name := resource.table.catalogName
    schema_name := resource.table.schemaName
    table_name := resource.table.tableName
    column_name := resource.table.column
    table_obj := abac_am.table_attributes(catalog_name, schema_name, table_name)
    utils.user_can_access_column(utils.user_id, catalog_name, schema_name, table_obj, column_name)
}



allow_for_resource_table(operation, resource) if {
    operation == "SelectFromColumns"
    utils.user_can_access_catalog(utils.user_id, resource.table.catalogName)
    resource.table.schemaName == "information_schema"
	resource.table.tableName == "schemata"
}

allow_for_resource_table(operation, resource) if { 
    operation == "SelectFromColumns"
    catalog_name := resource.table.catalogName
    schema_name := resource.table.schemaName
    table_name := resource.table.tableName
	utils.user_can_access_catalog(utils.user_id, catalog_name)
    resource.table.schemaName == "information_schema"
    resource.table.tableName in ["columns", "tables"]
}
