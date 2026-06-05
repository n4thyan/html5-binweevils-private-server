# Avatar Studio integration notes

Integrated into `bwr_mirror_site_fixed_v2.zip` using the uploaded `Weevil_Editor_Demo_Rotation_Colour_Pass.zip` only.

## Added
- `/weevil-studio` authenticated route
- `/api/me/avatar` GET/POST endpoints
- profile preview card and button into the studio
- uploaded Rotation + Colour pass assets under `public/js/avatar-studio/` and `public/css/avatar-studio.css`

## Saved user shape
Stored on each user record as `avatar`:
- `weevilDef`
- `expression`
- `proboscis`
- `hatId`
- `preferredRenderer`

## Important
This integration intentionally uses the uploaded Rotation + Colour pass, not the later SWF refine pass.
