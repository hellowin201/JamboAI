/// <reference types="vite/client" />

interface ImportMetaEnv {
  readonly VITE_JAMBOAI_APP_URL: string;
  readonly VITE_JAMBOAI_API_BASE_URL: string;
  readonly VITE_JAMBOAI_APP_ROLE: string;
}

interface ImportMeta {
  readonly env: ImportMetaEnv;
}
