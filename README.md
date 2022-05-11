# Relix

A simple SQL-backed recipe manager system.
Developed for educational purposes and to practice/study Elixir, Phoenix, Docker, TDD and hexagonal architectures.

Hex architecture references:
- https://jmgarridopaz.github.io/content/hexagonalarchitecture.html
- https://alistair.cockburn.us/hexagonal-architecture/
- https://aaronrenner.io/2019/09/18/application-layering-a-pattern-for-extensible-elixir-application-design.html

## Running

```console
docker-compose up -d
```
The web api service will be listening at http://localhost:4000

## Testing

```console
docker-compose run --rm -e "MIX_ENV=test" web mix test && docker-compose down
```


