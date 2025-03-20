#!/bin/bash

echo "Starting Docker cleanup process..."

# Remove all unused images, containers, and networks
echo "Pruning Docker system..."
docker system prune --all --force

# Remove all unused volumes
echo "Removing unused Docker volumes..."
docker volume prune --force

# Remove Docker build cache (if BuildKit is enabled)
echo "Cleaning Docker build cache..."
docker builder prune --all --force

# Stop Docker service before manual cleanup
echo "Stopping Docker service for manual cleanup..."
systemctl stop docker

# Remove orphaned overlay2 layers (for overlay2 storage driver)
echo "Clearing overlay2 storage layers..."
rm -rf /var/lib/docker/overlay2/*

# Remove lingering logs from containers
echo "Removing Docker container logs..."
rm -rf /var/lib/docker/containers/*/*.log

# Clean up Docker volumes directory (in case of orphaned data)
echo "Removing orphaned volumes..."
rm -rf /var/lib/docker/volumes/*

# Vacuum system journal logs (optional)
echo "Cleaning system logs related to Docker..."
journalctl --vacuum-size=100M

# Restart Docker service
echo "Restarting Docker service..."
systemctl start docker

echo "Docker cleanup completed successfully!"
