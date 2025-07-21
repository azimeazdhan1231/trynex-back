
# TryneX Backend - Quick Start

## Local Development
```bash
npm install
npm run db:migrate
npm run dev
```

## Environment Variables (.env)
```
NODE_ENV=production
DATABASE_URL=your_supabase_connection_string
SUPABASE_URL=https://wifsqonbnfmwtqvupqbk.supabase.co
SUPABASE_ANON_KEY=your_supabase_anon_key
PORT=5000
```

## Deploy to Render
1. Connect GitHub repo
2. Build: `npm install && npm run build`
3. Start: `npm start`
4. Add environment variables
