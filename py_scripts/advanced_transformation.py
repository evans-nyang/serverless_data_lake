import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job

# Get AWS account number from command line arguments
account_number = getResolvedOptions(sys.argv, ['ACCOUNT_NUMBER'])['ACCOUNT_NUMBER']

# Create GlueContext and SparkSession
glueContext = GlueContext(SparkContext.getOrCreate())
spark = glueContext.spark_session

# Create DynamicFrame from catalog
datasource0 = glueContext.create_dynamic_frame.from_catalog(
    database="sdl-demo-data",
    table_name="raw",
    transformation_ctx="datasource0"
)

# Perform transformations using DynamicFrames
dsTransformed = datasource0.drop_fields(['color', 'hour']).rename_field('imageUrl', 'thumbnailImageUrl').rename_field('campaign', 'campaignType')

# Print schema and show samples
dsTransformed.printSchema()
dsTransformed.show(10)

# Write transformed data to S3
glueContext.write_dynamic_frame.from_options(
    frame=dsTransformed,
    connection_type="s3",
    connection_options={"path": f"s3://sdl-immersion-day-{account_number}/output-etl-nb-jobs"},
    format="parquet"
)

# Write parquet data partitioned by department
dsTransformed.write.parquet(
    f's3://sdl-immersion-day-{account_number}/output-etl-nb-jobs/byDepartment',
    partitionBy=['department']
)
