import { Hono } from 'hono'
import { logger } from 'hono/logger'
import { serveStatic } from 'hono/bun'

const app = new Hono()

app.use(logger())
app.use('/favicon.ico', serveStatic({ path: './favicon.ico' }))
app.use('/pgp/sena.asc', serveStatic({ path: './pgp/sena.asc' }))
app.get('/', (c) => {
  const html = Bun.file('./index.html').text()
  return c.html(html)
})

export default app