import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  // Don't let `next dev` write AGENTS.md / CLAUDE.md. Agent instructions
  // live only in the root CLAUDE.md.
  agentRules: false,
  // The repo root has its own package-lock.json (Supabase CLI), so tell
  // Next.js this folder is the app's root instead of letting it guess.
  turbopack: {
    root: __dirname,
  },
};

export default nextConfig;
