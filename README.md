# imdb-stats

Loads some of the TSV files of https://datasets.imdbws.com/ into a MySQL server. Documentation of those datasets can be found at: https://www.imdb.com/interfaces/

To load the data edit `load-data.sh` to set your MySQL info and then run it:

```bash
./load-data.sh
```
This will require around 500MB in your `/tmp/` directory. After the data load is done, you can experiment with ad hoc queries. Examples:

## 1. [Top 50, highly rated movies since 1998](sample-1.txt):
```sql
select
    r.averageRating, r.numVotes, b.startYear, b.primaryTitle
from
    title_ratings r, title_basics b
where
    r.tconst = b.tconst and
    b.titleType = 'movie' and
    b.startYear > 1998 and
    r.numVotes > 100000 and
    r.averageRating > 6
order by r.averageRating desc
limit 50;
```

## 2. [Average rating of all highly rated movies by year](sample-2.txt):
```sql
select
    b.startYear, avg(averageRating)
from
    title_ratings r, title_basics b
where
    r.tconst = b.tconst and
    b.titleType = 'movie' and
    r.numVotes > 1000
group by b.startYear
order by b.startYear;
```

## 3. [Count of all movies rated more than 10 times](sample-3.txt):
```sql
select
    count(*)
from
    title_ratings r, title_basics b
where
    r.tconst = b.tconst and
    b.titleType = 'movie' and
    r.numVotes > 10;
```

## 4. [Average durations of good movies during the last 3 decades](sample-4.txt):
```sql
select
    b.startYear, avg(runtimeMinutes)
from
    title_ratings r, title_basics b
where
    r.tconst = b.tconst and
    b.titleType = 'movie' and
    r.numVotes > 1000 and
    r.averageRating > 7 and
    b.startYear > year(CURDATE()) - 30
group by b.startYear
order by b.startYear;
```