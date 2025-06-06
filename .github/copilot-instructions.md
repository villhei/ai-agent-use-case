## Database & SQL

- Always use `id` of uuid type for primary keys using `gen_random_uuid`
- Use `created_at` timestamps for all tables
- Set up the trigger function `set_updated_at` for each table for all updates
- Prefer non-nullable types where possible
- Always set up table and column comments
- Prefer checks on upsert instead of enums