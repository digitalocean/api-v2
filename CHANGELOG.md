# Changelog

## 8-20-2014

  - Remove embedded action_ids from Droplet and Image.

## 8-06-2014

  - Fix return code to be 201 when creating actions.
  - List action_ids on Image.

## 7-25-2014
  
  - Add vcpus, memory, and disk to Droplet, remove those fields from the embedded Size object.
  - Size's `price_monthly` and `price_hourly` are now floats. `transfer` is now in TB as documented.

## 7-18-2014

  - Add features array for Droplet.

## 7-02-2014

  - Add `created_at` field for Droplet.
  - Changed default per_page size to 20.
  - Changed maximum per_page size to 200.

## 6-25-2014

 - Add `features` field for regions, an array of features available in that region.
 - Add `disable_backups` event for Droplet.

## 6-24-2014

 - Remove `X-` from all RateLimit headers.
 - Add `created_at` field to all instances of Image (images, snapshots, and backups).
