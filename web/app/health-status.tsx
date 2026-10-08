"use client";

// Runs in the browser, so this call also checks the API's CORS setup.

import { useEffect, useState } from "react";

const API_URL = process.env.NEXT_PUBLIC_API_URL ?? "http://localhost:8000";

export default function HealthStatus() {
  const [status, setStatus] = useState("checking…");

  useEffect(() => {
    fetch(`${API_URL}/health`)
      .then((res) => (res.ok ? res.json() : Promise.reject(res.status)))
      .then((body: { status?: string }) =>
        setStatus(body.status ?? "unexpected response"),
      )
      .catch(() => setStatus("unreachable"));
  }, []);

  return (
    <p>
      API: {status}
      {status === "unreachable" && ` (is it running at ${API_URL}?)`}
    </p>
  );
}
