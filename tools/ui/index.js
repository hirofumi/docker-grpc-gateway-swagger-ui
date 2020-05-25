const express = require('express')
const swaggerUI = require('swagger-ui-dist')
const app = express()

app.get('/', (req, res, next) => {
  if (req.url === '/') {
    return res.redirect('/?url=/api/' + process.env.SWAGGER_JSON)
  }
  next()
})
app.use('/api', express.static('/api'))
app.use('/', express.static(swaggerUI.getAbsoluteFSPath()))
app.listen(process.env.PORT)
