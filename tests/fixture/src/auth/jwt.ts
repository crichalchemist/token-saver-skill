export interface TokenClaims {
  sub: string;
  exp: number;
}

// Verify an HS256 JWT against `secret` and return its claims, or throw.
export function verifyToken(token: string, secret: string): TokenClaims {
  throw new Error("not implemented");
}
