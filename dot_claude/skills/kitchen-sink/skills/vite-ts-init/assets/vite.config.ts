import { defineConfig } from 'vite'
import tailwindcss from '@tailwindcss/vite'
import devtoolsJson from 'vite-plugin-devtools-json'

export default defineConfig({
    plugins: [
        tailwindcss(),
        // https://github.com/ChromeDevTools/vite-plugin-devtools-json
        // Enables Chrome DevTools to auto-connect to the local project folder as a Workspace
        devtoolsJson(),
    ],
})
