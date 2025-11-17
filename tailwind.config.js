/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./site/**/*.html", "./site/**/*.js"],
  theme: {
    extend: {
      boxShadow: {
        'puck': '0 0 3px 0 #0003,0 2px 0 0 #0000001a'
      },
      colors: {
        'sidecar-gray': '#262625',
      },
      fontFamily: {
        'rounded': ['ui-rounded', '-apple-system', 'system-ui', 'BlinkMacSystemFont', '"Segoe UI"', 'Roboto', '"Helvetica Neue"', 'Arial', 'sans-serif'],
      }
    },
    container: {
      center: true
    },
    screens: {
      'sm': '375px',
      'md': '900px',
    }
  },
  plugins: [],
}
