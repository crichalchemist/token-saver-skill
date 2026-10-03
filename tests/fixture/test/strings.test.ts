import { describe, expect, it } from "vitest";
import { slugify } from "../src/utils/strings";

describe("slugify", () => {
  it("turns titles into url-safe slugs", () => {
    expect(slugify("  Hello, World! ")).toBe("hello-world");
  });
});
