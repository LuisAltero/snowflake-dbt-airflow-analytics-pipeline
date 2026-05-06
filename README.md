# Arquivos para o projeto `snowflake-dbt-airflow-portfolio`

Este arquivo reúne os conteúdos recomendados para documentação e limpeza do repositório do projeto de portfólio com **Snowflake + dbt + Airflow/Astro**.

---

# 1. `.gitignore`

Crie ou substitua o arquivo `.gitignore` na raiz do projeto com o conteúdo abaixo:

```gitignore
# =====================================================
# Python
# =====================================================
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
.python-version

# Virtual environments
venv/
env/
.venv/
dbt-env/

# Python build artifacts
build/
dist/
*.egg-info/
.eggs/

# =====================================================
# dbt
# =====================================================
dbt_project/target/
dbt_project/dbt_packages/
dbt_project/logs/
dbt_project/package-lock.yml

# Keep dbt package definition
!dbt_project/packages.yml

# dbt credentials
dbt_project/profiles.yml

# =====================================================
# Airflow / Astro
# =====================================================
logs/
plugins/__pycache__/
dags/__pycache__/

# Astro local config/cache
.astro/
airflow.db
webserver_config.py

# =====================================================
# Environment variables / secrets
# =====================================================
.env
.env.*
!.env.example

# =====================================================
# OS / Editor files
# =====================================================
.DS_Store
Thumbs.db
.vscode/
.idea/

# =====================================================
# Misc
# =====================================================
*.log
*.tmp
*.bak
```

---

# 2. `.env.example`

Como o `.env` será ignorado no Git, crie um arquivo `.env.example` na raiz do projeto:

```env
SNOWFLAKE_ACCOUNT=your_account
SNOWFLAKE_USER=your_user
SNOWFLAKE_PASSWORD=your_password
SNOWFLAKE_ROLE=your_role
SNOWFLAKE_DATABASE=your_database
SNOWFLAKE_WAREHOUSE=your_warehouse
```

---

# 3. `dbt_project/profiles.yml.example`

Como o `profiles.yml` será ignorado no Git, crie um arquivo de exemplo em `dbt_project/profiles.yml.example`:

```yml
snowflake_tpch_analytics:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: "{{ env_var('SNOWFLAKE_ACCOUNT') }}"
      user: "{{ env_var('SNOWFLAKE_USER') }}"
      password: "{{ env_var('SNOWFLAKE_PASSWORD') }}"
      role: "{{ env_var('SNOWFLAKE_ROLE') }}"
      database: "{{ env_var('SNOWFLAKE_DATABASE') }}"
      warehouse: "{{ env_var('SNOWFLAKE_WAREHOUSE') }}"
      schema: dbt_schema
      threads: 4
      client_session_keep_alive: false
```

---

# 4. `README.md`

Substitua o conteúdo do `README.md` da raiz pelo conteúdo abaixo:

```md
# Snowflake dbt Airflow Portfolio Project

End-to-end analytics engineering project using **Snowflake**, **dbt** and **Apache Airflow/Astro**.

This project transforms raw sample data from Snowflake's `SNOWFLAKE_SAMPLE_DATA.TPCH_SF1` into a dimensional analytics model using a layered architecture:

- **Staging**
- **Intermediate**
- **Marts**
- **Facts and dimensions**
- **Data quality tests**
- **Reusable dbt macros**
- **Airflow orchestration**

---

## Project Objective

The goal of this project is to simulate a modern analytics engineering pipeline for a B2B sales operation.

The pipeline transforms raw TPCH data into curated analytical tables that can be consumed by BI tools, dashboards or data products.

Business questions supported by this model include:

- What is the total revenue by region?
- Which customers generate the most revenue?
- What is the late delivery rate?
- Which product categories perform better?
- What is the revenue evolution over time?
- Which suppliers are associated with higher sales volume?

---

## Architecture

```text
SNOWFLAKE_SAMPLE_DATA.TPCH_SF1
        |
        v
dbt Sources
        |
        v
Staging Layer
        |
        v
Intermediate Layer
        |
        v
Marts Layer
        |
        v
Facts and Dimensions
        |
        v
Airflow / Astro Orchestration
```

---

## Tech Stack

| Tool | Purpose |
|---|---|
| Snowflake | Cloud data warehouse |
| Snowflake Sample Data | Raw data source |
| dbt | Data transformation and modeling |
| Airflow | Pipeline orchestration |
| Astro CLI | Local Airflow development |
| Docker | Container runtime |
| Python | Runtime environment |

---

## Data Source

This project uses the official Snowflake sample dataset:

```sql
SNOWFLAKE_SAMPLE_DATA.TPCH_SF1
```

Main source tables:

- `CUSTOMER`
- `ORDERS`
- `LINEITEM`
- `PART`
- `SUPPLIER`
- `NATION`
- `REGION`
- `PARTSUPP`

---

## Project Structure

```text
snowflake-dbt-airflow-portfolio/
│
├── dags/
│   └── dbt_tpch_pipeline.py
│
├── dbt_project/
│   ├── analyses/
│   ├── macros/
│   ├── models/
│   │   ├── staging/
│   │   ├── intermediate/
│   │   └── marts/
│   ├── seeds/
│   ├── snapshots/
│   ├── tests/
│   ├── dbt_project.yml
│   ├── packages.yml
│   └── profiles.yml.example
│
├── include/
├── plugins/
├── tests/
├── Dockerfile
├── packages.txt
├── requirements.txt
├── airflow_settings.yaml
├── .env.example
├── .gitignore
└── README.md
```

---

## dbt Layers

### 1. Staging Layer

The staging layer standardizes raw source tables.

Main responsibilities:

- Rename columns
- Cast data types
- Clean string fields
- Keep one-to-one relationship with source tables
- Avoid business logic

Example models:

- `stg_tpch_customers`
- `stg_tpch_orders`
- `stg_tpch_line_items`
- `stg_tpch_parts`
- `stg_tpch_suppliers`
- `stg_tpch_nations`
- `stg_tpch_regions`

---

### 2. Intermediate Layer

The intermediate layer applies business logic and joins between staging models.

Example models:

- `int_order_items`
- `int_customer_enriched`
- `int_supplier_enriched`
- `int_part_supplier`

This layer prepares the data for final marts without exposing it directly to business users.

---

### 3. Marts Layer

The marts layer contains final analytical models ready for reporting and BI consumption.

Dimensions:

- `dim_customers`
- `dim_suppliers`
- `dim_parts`
- `dim_geography`
- `dim_dates`

Facts:

- `fct_orders`
- `fct_order_items`
- `fct_sales_daily`

---

## Dimensional Model

### Fact Tables

#### `fct_order_items`

Grain: one row per order item.

Includes:

- Order item surrogate key
- Customer ID
- Product ID
- Supplier ID
- Order date
- Ship date
- Quantity
- Gross revenue
- Net revenue
- Late delivery flag

#### `fct_orders`

Grain: one row per order.

Includes:

- Order ID
- Customer ID
- Total items
- Total quantity
- Gross revenue
- Net revenue
- Average discount
- Late delivery flag

#### `fct_sales_daily`

Grain: one row per day, region, nation, market segment and order priority.

Includes:

- Total orders
- Total customers
- Total quantity
- Gross revenue
- Net revenue
- Late delivery rate

---

### Dimension Tables

#### `dim_customers`

Customer attributes enriched with geography.

#### `dim_suppliers`

Supplier attributes enriched with geography.

#### `dim_parts`

Product and part attributes.

#### `dim_geography`

Nation and region hierarchy.

#### `dim_dates`

Calendar dimension generated from order and receipt dates.

---

## Data Quality

This project includes dbt tests for:

- Primary key uniqueness
- Not null fields
- Relationship integrity
- Positive numeric values
- Dates not in the future
- Revenue validation

Examples:

```bash
dbt test
dbt test --select staging
dbt test --select marts
dbt test --select test_type:generic
dbt test --select test_type:singular
```

---

## Custom dbt Macros

The project includes reusable macros:

| Macro | Purpose |
|---|---|
| `clean_string` | Standardizes text fields |
| `generate_surrogate_key` | Creates surrogate keys |
| `safe_divide` | Avoids division by zero |
| `date_spine` | Generates date ranges |

---

## Airflow DAG

The pipeline is orchestrated by the DAG:

```text
dbt_snowflake_tpch_pipeline
```

DAG steps:

```text
dbt_deps
  >> dbt_debug
  >> dbt_run_staging
  >> dbt_test_staging
  >> dbt_run_intermediate
  >> dbt_run_marts
  >> dbt_test_marts
  >> dbt_docs_generate
```

---

## Local Setup

### 1. Clone the repository

```bash
git clone <repository-url>
cd snowflake-dbt-airflow-portfolio
```

---

### 2. Create environment files

Create `.env` based on `.env.example`:

```bash
cp .env.example .env
```

Fill in your Snowflake credentials:

```env
SNOWFLAKE_ACCOUNT=your_account
SNOWFLAKE_USER=your_user
SNOWFLAKE_PASSWORD=your_password
SNOWFLAKE_ROLE=your_role
SNOWFLAKE_DATABASE=your_database
SNOWFLAKE_WAREHOUSE=your_warehouse
```

Create `profiles.yml` based on the example:

```bash
cp dbt_project/profiles.yml.example dbt_project/profiles.yml
```

---

### 3. Install dbt dependencies locally

```bash
cd dbt_project
dbt deps
```

---

### 4. Validate dbt connection

```bash
dbt debug
```

---

### 5. Run dbt models

```bash
dbt run
```

---

### 6. Run dbt tests

```bash
dbt test
```

---

### 7. Generate dbt documentation

```bash
dbt docs generate
dbt docs serve
```

---

## Running with Astro and Airflow

Make sure Docker Desktop is running.

From the project root:

```bash
astro dev start
```

Open Airflow UI:

```text
http://localhost:8080
```

Then:

1. Find the DAG `dbt_snowflake_tpch_pipeline`
2. Enable the DAG
3. Trigger a manual run
4. Monitor task execution in Grid or Graph view

---

## Astro Requirements

The following Python dependencies are defined in `requirements.txt`:

```txt
dbt-core
dbt-snowflake
apache-airflow-providers-snowflake
```

The following Linux package is defined in `packages.txt`:

```txt
git
```

`git` is required because dbt uses it to install packages such as `dbt_utils`.

---

## Example Analytical Queries

### Revenue by Region

```sql
select
    region_name,
    sum(net_revenue) as net_revenue,
    sum(total_orders) as total_orders
from marts.fct_sales_daily
group by region_name
order by net_revenue desc;
```

### Late Delivery Rate by Order Priority

```sql
select
    order_priority,
    avg(late_delivery_rate) as avg_late_delivery_rate
from marts.fct_sales_daily
group by order_priority
order by avg_late_delivery_rate desc;
```

### Revenue by Market Segment

```sql
select
    market_segment,
    sum(net_revenue) as net_revenue,
    sum(total_orders) as total_orders
from marts.fct_sales_daily
group by market_segment
order by net_revenue desc;
```

---

## Portfolio Highlights

This project demonstrates practical experience with:

- Cloud data warehouse architecture
- Snowflake SQL
- dbt modeling
- Layered ELT architecture
- Dimensional modeling
- Fact and dimension design
- Incremental models
- Data quality tests
- Reusable macros
- Airflow orchestration
- Docker-based local development
- Analytics engineering best practices

---

## Future Improvements

Possible next steps:

- Add BI dashboard using Power BI or Streamlit
- Add CI/CD with GitHub Actions
- Add dbt exposures
- Add freshness checks
- Add snapshots for slowly changing dimensions
- Add source freshness monitoring
- Add Great Expectations or Soda for additional data quality
```

---