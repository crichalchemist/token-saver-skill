export function slugify(input: string): string {
  return input.toLowerCase().trim().replace(/[^a-z0-9]+/g, "-").replace(/^-|-$/g, "");
}

export function truncate(input: string, max: number): string {
  return input.length <= max ? input : input.slice(0, max - 1) + "…";
}

export function initials(name: string): string {
  return name.split(/\s+/).filter(Boolean).map((p) => p[0]!.toUpperCase()).join("");
}
