# Recipe Store perfomance result

Execute on 
- CPU: 11th Gen Intel® Core™ i7-1165G7 @ 2.80GHz × 8
- RAM: 32 GB.
- OS: Ubuntu 20.04.4 LTS


## Test with 100 concurrent processes (only Postgres)

### PostgresStore (pool size 100):
- average new_recipe 16311.13 μs (16 ms)
- average get_recipe 14165.75 μs (14 ms)

### PostgresStore (pool size 10):
- average new_recipe 13765.48 μs (13 ms)
- average get_recipe 5839.1 μs (6 ms)

### PostgresStore (pool size 1):
- average new_recipe 63582.87 μs (63 ms)
- average get_recipe 17252.21 μs (17 ms)

## Test with 1000 concurrent processes

### InMemoryStore:
- average put 3228.814 μs (3 ms)
- average get 41.25 μs (0.04 ms)

### EtsStore:
- average put 2451.601 μs (2 ms)
- average get 0.1 μs (0.0001 ms)

### PostgresStore (pool size 100):
- average put 62983.471 μs (62 ms)
- average get 42431.404 μs (42 ms)

## Test with 10_000 concurrent processes

### InMemoryStore:
- average put 869.26746 μs (0.8 ms)
- average get 70.54952 μs (0.07 ms)

### EtsStore:
- average put 250.601 μs (0.2 ms)
- average get 0.09 μs (0.00009 ms)

### PostgresStore (pool size 100):
- average new_recipe 587479.283 μs (587 ms)
- average get_recipe 234919.91 μs (234 ms)

## Test with 100_000 concurrent processes

### InMemoryStore:
- average put 4582.26746 μs (4 ms)
- average get 259.54952 μs (0.2 ms)

### EtsStore:
- average put 300.601 μs (0.3 ms)
- average get 0.17 μs (0.0002 ms)

## PostgresStore:
Pool size 100. Can't increase or we get a too_many_connections error from Postgres

(DBConnection.ConnectionError) connection not available and request was dropped from queue after 1548ms. This means requests are coming in and your connection pool cannot serve them fast enough. 

## Test with 1_000_000 concurrent processes

### InMemoryStore:
- average put 61627.234867 μs (61 ms)
- average get 10669.876854 μs (10 ms)

Single agent bottleneck!

### EtsStore:
- average put 28.601 μs (0.03 ms)
- average get 0.22 μs (0.0002 ms)

