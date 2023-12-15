import boto3

def generate_etl_script(transformations, bucket_name):
    script = f"""
    import sys
    from awsglue.utils import getResolvedOptions
    from awsglue.transforms import *
    from awsglue.context import GlueContext
    from pyspark.context import SparkContext

    args = getResolvedOptions(sys.argv, ['JOB_NAME', 'output-path', 'database-name', 'table-name', 'bucket-name'])
    output_path = args['output-path']
    database_name = args['database-name']
    table_name = args['table-name']
    bucket_name = args['bucket-name']

    sc = SparkContext()
    glueContext = GlueContext(sc)

    datasource0 = glueContext.create_dynamic_frame.from_catalog(
        database = database_name, 
        table_name = table_name
    )

    # Apply transformations
    {transformations}

    glueContext.write_dynamic_frame.from_options(
        frame = transformed_data,
        connection_type = "s3",
        connection_options = {{"path": output_path}},
        format = "parquet"
    )
    """

    s3 = boto3.resource('s3')
    s3.Object(bucket_name, 'scripts/transform-json-to-parquet.py').put(Body=script.encode('utf-8'))

# Define transformations
transformations = """
# Apply mapping
mapped_data = ApplyMapping.apply(frame = datasource0, mappings = [
    ("productname", "string", "productname", "string"),
    ("department", "string", "department", "string"),
    ("product", "string", "product", "string"),
    ("imageurl", "string", "imageurl", "string"),
    ("datesoldsince", "string", "date_start", "string"),
    ("datesolduntil", "string", "date_until", "string"),
    ("price", "int", "price", "int"),
    ("campaign", "string", "campaign", "string"),
    ("year", "string", "year", "string"),
    ("month", "string", "month", "string"),
    ("day", "string", "day", "string"),
    ("hour", "string", "hour", "string")  
])

# Drop color field
# transformed_data = DropFields.apply(frame = mapped_data, paths = ["color"])
"""

# Generate the ETL script
bucket_name = input("Enter the bucket name: ")
generate_etl_script(transformations, bucket_name)
