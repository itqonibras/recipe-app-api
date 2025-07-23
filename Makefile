.PHONY: flake8 test migrate makemigrations shell createsuperuser build up down

# Linting
flake8:
	docker compose run --rm app sh -c "flake8"

# Testing
test:
	docker compose run --rm app sh -c "python manage.py test"

# Database
migrate:
	docker compose run --rm app sh -c "python manage.py migrate"

makemigrations:
	docker compose run --rm app sh -c "python manage.py makemigrations"

# Development
shell:
	docker compose run --rm app sh -c "python manage.py shell"

createsuperuser:
	docker compose run --rm app sh -c "python manage.py createsuperuser"

# Docker
build:
	docker compose build

up:
	docker compose up

down:
	docker compose down

# Clean up
clean:
	docker compose down -v --remove-orphans
	docker system prune -f
