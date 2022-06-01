# Volume
NOTE:
Volumes can be attached either directly on the digitalocean_droplet resource, or using the digitalocean_volume_attachment resource - but the two cannot be used together. If both are used against the same Droplet, the volume attachments will constantly drift.