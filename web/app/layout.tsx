import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "Huigan",
  description: "A tea journal that learns your palate.",
};

export default function RootLayout({ children }: LayoutProps<"/">) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
