let bodyParser = require('body-parser');
let web3module = require('./web3module.js');
let storage = require('./storage');

module.exports = function appInit(app) {
  app.use(function (req, res, next) {
    if (req.headers.origin) {
      res.header('Access-Control-Allow-Origin', req.headers.origin);
      res.header('Access-Control-Allow-Methods', 'GET, PUT, POST, PUT, DELETE');
      res.header('Access-Control-Allow-Headers', 'Content-Type, Authorization, Content-Length, X-Requested-With');
      res.setHeader('Access-Control-Allow-Credentials', 'true');
    }
    //intercepts OPTIONS method
    if ('OPTIONS' === req.method) {
      //req.method = req.headers["access-control-request-method"]
      res.send("ok")
    } else {
      next();
    }
  });
  app.use(bodyParser.json());

  app.get(/^\/player_status/, (req, res) => {
    let address = req.query.address || '';
    let id = req.query.id;
    if (address) {
      web3module.player_status_from_address(address).subscribe((data) => {
        res.send(data);
      });
    } else if (id) {
      web3module.player_status_from_id(id).subscribe((data) => {
        res.send(data);
      });
    }else{
      res.send('{"success":false}');
    }
  })
  app.get(/^\/getInfo/, (req, res) => {
    res.send(web3module.getInto());
  })

  app.post(/^\/settlement/, (req, res) => {
    let address = req.body.address;
    let final_balance = req.body.final_balance;
    web3module.settlement(address, final_balance).subscribe((data) => {
      res.send({
        order_id: data
      });
    });
  })

  app.post(/^\/finish/, (req, res) => {
    let address = req.body.address;
    web3module.finish(address).subscribe((data) => {
      res.send({
        order_id: data
      });
    });
  })

  app.get(/^\/order_status/, async(req, res) => {
    let order_id = req.query.order_id;
    let order = await storage.getOrder(order_id);
    order = JSON.parse(JSON.stringify(order));
    res.send({
      status: order.status
    });
  })

  app.get(/^\/received_ranking/, (req, res) => {
    res.send({
      players: web3module.received_ranking()
    });
  })
  app.get(/^\/contribution_ranking/, (req, res) => {
    res.send({
      players: web3module.contribution_ranking()
    });
  })
  app.get(/^\/winOrLose_ranking/, (req, res) => {
    res.send({
      players: web3module.winOrLose_ranking()
    });
  })
  app.get(/^\/received_history/, async (req, res) => {
    let start = req.query.start || '0x0';
    let end = req.query.end || 'latest';
    let result = JSON.parse(await web3module.received_history(start, end))
    res.send( result.result )
  })
  app.post(/^\/deWater/,(req,res)=>{
    web3module.deWater().subscribe((data)=>{
      res.send({
        order_id: data
      });
    })
  })
  
}
