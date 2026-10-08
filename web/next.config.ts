import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  // Don't let `next dev` write AGENTS.md / CLAUDE.md. Agent instructions
  // live only in the root CLAUDE.md.
  agentRules: false,
};

export default nextConfig;
