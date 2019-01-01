// setup express and handlebars
var express = require('express');
var dbcon = require('./dbcon.js');
var mysql = require('mysql');

var pool;

// https://github.com/mysqljs/mysql/issues/1694
// https://stackoverflow.com/questions/20210522/nodejs-mysql-error-connection-lost-the-server-closed-the-connection
function startServer() {
 pool = mysql.createConnection(dbcon);

 pool.connect(function(err) {
    if(err) {
      console.log('error when connecting to db:', err);
      setTimeout(startServer, 5000);
    }
  });

  pool.on('error', function(err) {
    console.log('db error', err);
    if(err.fatal) {
      startServer();
    }
  });
}

startServer();

var app = express();
var handlebars = require('express-handlebars').create({defaultLayout:'main'});

app.engine('handlebars', handlebars.engine);
app.set('view engine', 'handlebars');

// set port number to command line argument
app.set('port', process.argv[2]);

app.use(express.static('public'));

app.get('/search',function(req,res,next){
    var context = {};
    var sql = `SELECT * FROM users WHERE (users.name LIKE "%"?"%")`;
    inserts = [req.query.search, req.query.search];

    pool.query(sql,inserts, function(err, rows, fields){
        if(err){
            next(err);
            return;
        }
        context.users = rows;

        sql = `SELECT * FROM materials WHERE (materials.name LIKE "%"?"%")`;
        inserts = [req.query.search];

        pool.query(sql,inserts, function(err, rows, fields){
            if(err){
                next(err);
                return;
            }
            context.materials = rows;

            sql = `SELECT * FROM centers WHERE (centers.name LIKE "%"?"%")`;
            inserts = [req.query.search];

            pool.query(sql,inserts, function(err, rows, fields){
                if(err){
                    next(err);
                    return;
                }
                context.centers = rows;


                sql = `SELECT * FROM schedules WHERE (schedules.day_of_week LIKE "%"?"%")`;
                inserts = [req.query.search];

                pool.query(sql,inserts, function(err, rows, fields){
                    if(err){
                        next(err);
                        return;
                    }
                    context.schedules = rows;


                    sql = `SELECT DISTINCT C.id AS cid, U.id AS uid, C.name AS cname, U.name AS uname FROM users_centers UC INNER JOIN users U ON UC.cid = U.id INNER JOIN centers C ON UC.cid = C.id WHERE (U.name LIKE "%"?"%") OR (C.name LIKE "%"?"%")`;
                    inserts = [req.query.search, req.query.search];

                    pool.query(sql,inserts, function(err, rows, fields){
                        if(err){
                            next(err);
                            return;
                        }
                        context.users_centers = rows;

                        res.render('search', context);
                    });
                });
            });
        });
    });
});


app.get('/search-materials',function(req,res,next){
    var context = {};
    context.layout = false;

    sql = `SELECT * FROM materials WHERE (materials.name LIKE "%"?"%") ORDER BY materials.name;`;
    inserts = [req.query.search];

    pool.query(sql,inserts, function(err, rows, fields){
        if(err){
            next(err);
            return;
        }
        context.materials = rows;
        res.render('search-materials', context);
    });
});


app.get('/search-handling',function(req,res,next){
    var context = {};
    context.layout = false;

    sql = `SELECT H.instructions FROM materials_handling MH
    INNER JOIN materials M ON M.id = MH.mid
    INNER JOIN handlingInstructions H ON H.id = MH.HID
    WHERE (M.name = ?)`;

    inserts = [req.query.search];

    pool.query(sql,inserts, function(err, rows, fields){
        if(err){
            next(err);
            return;
        }
        context.instructions = rows;
        res.render('search-handling', context);
    });
});

app.get('/search-centers',function(req,res,next){
    var context = {};
    context.layout = false;

    sql = `SELECT C.name, C.street_number, C.street_direction, C.street_name, C.street_type, C.city, C.state, C.zip FROM centers_materials CM
    INNER JOIN centers C ON C.id = CM.CID
    INNER JOIN materials M ON M.id = CM.MID
    WHERE (M.name = ?) ORDER BY C.name;`;

    inserts = [req.query.search];

    pool.query(sql,inserts, function(err, rows, fields){
        if(err){
            next(err);
            return;
        }
        context.centers = rows;
        res.render('search-centers', context);
    });
});


app.get('/search-schedules',function(req,res,next){
    var context = {};
    context.layout = false;

    sql = `SELECT S.time_open, S.time_closed,
        CASE
    WHEN S.day_of_week = 1 THEN "sunday"
    WHEN S.day_of_week = 2 THEN "monday"
    WHEN S.day_of_week = 3 THEN "tuesday"
    WHEN S.day_of_week = 4 THEN "wednesday"
    WHEN S.day_of_week = 5 THEN "thursday"
    WHEN S.day_of_week = 6 THEN "friday"
    WHEN S.day_of_week = 7 THEN "saturday"
    ELSE "invalid day number"
    END AS day_of_week
    FROM centers C INNER JOIN schedules S ON C.id = S.cid
    WHERE (C.name = ""?"");`;


    inserts = [req.query.search];


    pool.query(sql,inserts, function(err, rows, fields){
        if(err){
            next(err);
            return;
        }
        context.schedules = rows;
        res.render('search-schedules', context);
    });
});

//SELECT materials.name FROM materials INNER JOIN centers_materials ON centers_materials.mid = materials.id INNER JOIN centers on centers.id = centers_materials.cid WHERE Centers.name LIKE "%Cool%";
app.get('/search-centers-materials',function(req,res,next){
    var context = {};
    context.layout = false;

    sql = `SELECT M.name FROM centers_materials CM
    INNER JOIN centers C ON C.id = CM.CID
    INNER JOIN materials M ON M.id = CM.MID
    WHERE (C.name = ""?"") ORDER BY M.name;`;

    inserts = [req.query.search];

    pool.query(sql,inserts, function(err, rows, fields){
        if(err){
            next(err);
            return;
        }
        context.materials = rows;
        res.render('search-centers-materials', context);
    });
});


app.get('/search-all-centers',function(req,res,next){
    var context = {};
    context.layout = false;

    sql = `SELECT * FROM centers WHERE (centers.name LIKE "%"?"%") ORDER BY centers.name;`;

    inserts = [req.query.search];

    pool.query(sql,inserts, function(err, rows, fields){
        if(err){
            next(err);
            return;
        }
        context.centers = rows;
        res.render('search-all-centers', context);
    });
});


app.get('/search-disposal',function(req,res,next){
    var context = {};
    context.layout = false;

    sql = `SELECT D.instructions FROM materials_disposal MD
    INNER JOIN materials M on M.id = MD.mid
    INNER JOIN disposalInstructions D on D.id = MD.did
    WHERE (M.name = ?);`;

    inserts = [req.query.search];

    pool.query(sql,inserts, function(err, rows, fields){
        if(err){
            next(err);
            return;
        }
        context.disposal = rows;
        res.render('search-disposal', context);
    });
});

app.get('/users',function(req,res,next){
    var context = {};
    sql = 'SELECT * FROM users';
    pool.query(sql, function(err, rows, fields){
        if(err){
            next(err);
            return;
        }
        context.users = rows;
        context.table = "users";
        res.render('users', context);
    });
});

app.get('/materials-search',function(req,res,next){
    var context = {};
    sql = 'SELECT * FROM materials ORDER BY name';
    pool.query(sql, function(err, rows, fields){
        if(err){
            next(err);
            return;
        }
        context.materials = rows;
        context.table = "materials";
        res.render('materials-search', context);
    });
});

app.get('/centers-search',function(req,res,next){
    var context = {};
    sql = 'SELECT * FROM centers ORDER BY name';
    pool.query(sql, function(err, rows, fields){
        if(err){
            next(err);
            return;
        }
        context.centers = rows;
        context.table = "centers";
        res.render('centers-search', context);
    });
});

app.get('/materials',function(req,res,next){
    var context = {};
    sql = 'SELECT * FROM materials WHERE id = ? ORDER BY name';
    inserts = [req.query.id];
    pool.query(sql, inserts, function(err, rows, fields){
        if(err){
            next(err);
            return;
        }
        context.materials = rows;

        sql = `SELECT H.instructions FROM materials_handling MH
        INNER JOIN materials M ON M.id = MH.mid
        INNER JOIN handlingInstructions H ON H.id = MH.HID
        WHERE (M.id = ?)`;

        inserts = [req.query.id];
        pool.query(sql, inserts, function(err, rows, fields){
            if(err){
                next(err);
                return;
            }
            context.handling = rows;

            sql = `SELECT D.instructions FROM materials_disposal MD
            INNER JOIN materials M on M.id = MD.mid
            INNER JOIN disposalInstructions D on D.id = MD.did
            WHERE (M.id = ?);`;

            inserts = [req.query.id];
            pool.query(sql, inserts, function(err, rows, fields){
                if(err){
                    next(err);
                    return;
                }
                context.disposal = rows;

                sql = `SELECT C.* FROM centers_materials CM
                INNER JOIN centers C ON C.id = CM.CID
                INNER JOIN materials M ON M.id = CM.MID
                WHERE (M.id = ?) ORDER BY C.name;`;

                inserts = [req.query.id];
                pool.query(sql, inserts, function(err, rows, fields){
                    if(err){
                        next(err);
                        return;
                    }
                    context.centers = rows;


                    context.table = "materials";
                    res.render('materials', context);
                });
            });
        });
    });
});



app.get('/about',function(req,res,next){
    var context = {};
    res.render('about', context);
});

app.get('/materials-dev',function(req,res,next){
    sql = `SELECT H.instructions FROM materials_handling MH
    INNER JOIN materials M ON M.id = MH.mid
    INNER JOIN handlingInstructions H ON H.id = MH.HID
    WHERE (M.name = ?)`;
    var context = {};
    sql = 'SELECT * FROM materials';
    pool.query(sql, function(err, rows, fields){
        if(err){
            next(err);
            return;
        }
        context.materials = rows;
        context.table = "materials";
        res.render('materials-dev', context);
    });
});


app.get('/handlingInstructions',function(req,res,next){
    var context = {};
    sql = 'SELECT * FROM handlingInstructions';
    pool.query(sql, function(err, rows, fields){
        if(err){
            next(err);
            return;
        }
        context.handlingInstructions = rows;
        context.table = "handlingInstructions";
        res.render('handlingInstructions', context);
    });
});


app.get('/disposalInstructions',function(req,res,next){
    var context = {};
    sql = 'SELECT * FROM disposalInstructions';
    pool.query(sql, function(err, rows, fields){
        if(err){
            next(err);
            return;
        }
        context.disposalInstructions = rows;
        context.table = "disposalInstructions";
        res.render('disposalInstructions', context);
    });
});

app.get('/centers-dev',function(req,res,next){
    var context = {};
    sql = 'SELECT * FROM centers';
    pool.query(sql, function(err, rows, fields){
        if(err){
            next(err);
            return;
        }
        context.centers = rows;
        context.table = "centers";
        res.render('centers-dev', context);
    });
});

app.get('/centers',function(req,res,next){
    var context = {};
    sql = 'SELECT * FROM centers WHERE id = ?';
    inserts = [req.query.id];
    pool.query(sql, inserts, function(err, rows, fields){
        if(err){
            next(err);
            return;
        }
        context.centers = rows;

        sql = `
        SELECT S.id, S.day_of_week, S.time_open, S.time_closed,
            CASE
        WHEN S.day_of_week = 1 THEN "sunday"
        WHEN S.day_of_week = 2 THEN "monday"
        WHEN S.day_of_week = 3 THEN "tuesday"
        WHEN S.day_of_week = 4 THEN "wednesday"
        WHEN S.day_of_week = 5 THEN "thursday"
        WHEN S.day_of_week = 6 THEN "friday"
        WHEN S.day_of_week = 7 THEN "saturday"
        ELSE "invalid day number"
        END AS day_of_week
        FROM centers C INNER JOIN schedules S ON C.id = S.cid
        WHERE cid = ?`;

        inserts = [req.query.id];
        pool.query(sql, inserts, function(err, rows, fields){
            if(err){
                next(err);
                return;
            }

            context.schedules = rows;

            sql = `SELECT M.name FROM centers_materials CM
            INNER JOIN centers C ON C.id = CM.CID
            INNER JOIN materials M ON M.id = CM.MID
            WHERE C.id = ? ORDER BY M.name;`;

            inserts = [req.query.id];
            pool.query(sql, inserts, function(err, rows, fields){
                if(err){
                    next(err);
                    return;
                }

                context.materials = rows;
                context.table = "centers";
                res.render('centers', context);
            });
        });
    });
});



app.get('/schedules',function(req,res,next){
    var context = {};
    sql = `
    SELECT S.id, S.day_of_week, S.time_open, S.time_closed,
        CASE
    WHEN S.day_of_week = 1 THEN "sunday"
    WHEN S.day_of_week = 2 THEN "monday"
    WHEN S.day_of_week = 3 THEN "tuesday"
    WHEN S.day_of_week = 4 THEN "wednesday"
    WHEN S.day_of_week = 5 THEN "thursday"
    WHEN S.day_of_week = 6 THEN "friday"
    WHEN S.day_of_week = 7 THEN "saturday"
    ELSE "invalid day number"
    END AS day_of_week
    FROM centers C INNER JOIN schedules S ON C.id = S.cid`;


    pool.query(sql, function(err, rows, fields){
        if(err){
            next(err);
            return;
        }

        context.table = "schedules";
        context.schedules = rows;

        sql = 'SELECT * FROM centers';
        pool.query(sql, function(err, rows, fields){
            if(err){
                next(err);
                return;
            }
            context.centers = rows;
            res.render('schedules', context);
        });
    });
});


// home page (GET request)
app.get('/',function(req,res,next){
    var context = {};
    res.render('home', context);
});

// dev page (GET request)
app.get('/dev',function(req,res,next){
    var context = {};
    sql = 'SELECT COUNT(*) AS num FROM users';
    pool.query(sql, function(err, rows, fields){
        if(err){
            next(err);
            return;
        }
        context.users = rows;

        sql = 'SELECT COUNT(*) AS num FROM materials';
        pool.query(sql, function(err, rows, fields){
            if(err){
                next(err);
                return;
            }
            context.materials = rows;

            sql = 'SELECT COUNT(*) AS num FROM handlingInstructions';
            pool.query(sql, function(err, rows, fields){
                if(err){
                    next(err);
                    return;
                }
                context.handlingInstructions = rows;

                sql = 'SELECT COUNT(*) AS num FROM disposalInstructions';
                pool.query(sql, function(err, rows, fields){
                    if(err){
                        next(err);
                        return;
                    }
                    context.disposalInstructions = rows;

                    sql = 'SELECT COUNT(*) AS num FROM centers';
                    pool.query(sql, function(err, rows, fields){
                        if(err){
                            next(err);
                            return;
                        }
                        context.centers = rows;

                        sql = 'SELECT COUNT(*) AS num FROM schedules';
                        pool.query(sql, function(err, rows, fields){
                            if(err){
                                next(err);
                                return;
                            }
                            context.schedules = rows;
                            res.render('dev', context);
                        });
                    });
                });
            });
        });
    });
});



app.get('/issues',function(req,res,next){
    var context = {};
    sql = 'SELECT * FROM centers ORDER BY name';
    pool.query(sql, function(err, rows, fields){
        if(err){
            next(err);
            return;
        }
        context.centers = rows;
        res.render('issues', context);
    });
});

// POST request
var bodyParser = require('body-parser');
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());
var https = require('https');
let issue_auth = require('./issue-auth.js');

app.post('/issues-submit', function(req,res){
    var qParams = [];
    for (var p in req.body){
        qParams.push({'name':p,'value':req.body[p]})
    }
    console.log(qParams[0]);
    console.log(req.body);
    var context = {};
    context.dataList = qParams;
    context.title = qParams[0].value;
    context.body = qParams[1].value + '\n' + qParams[2].value;
    //res.render('post.handlebars', context);

    console.log("qParams[0]):", qParams[0].value);
    console.log("qParams[1]):", qParams[1].value);
    console.log("qParams[2]):", qParams[2].value);
    // https://stackoverflow.com/questions/6158933/how-to-make-an-http-post-request-in-node-js
    function PostCode(codestring) {
        // Build the post string from an object
        var post_data = JSON.stringify({
            'title' : qParams[0].value,
            'body': qParams[1].value + '\n' + qParams[2].value
        });
        console.log("postdata:", post_data);

        // An object of options to indicate where to post to
        var post_options = {
            //host: 'webdev.liambeckman.com',
            //path: '/getpost',
            host: 'api.github.com',
            path: '/repos/cs361-group24/database/issues',
            port: '443',
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Content-Length': Buffer.byteLength(post_data),
                'Authorization': issue_auth,
                'User-Agent': 'issuebot3000'
            }
        };

        // Set up the request
        var post_req = https.request(post_options, function(res) {
            res.setEncoding('utf8');
            res.on('data', function (chunk) {
                console.log('Response: ' + chunk);
            });
        });

        // post the data
        post_req.write(post_data);
        post_req.end();

    }

    PostCode('');
    res.render("issues-submit.handlebars", context);
});



app.get('/insert',function(req,res,next){
    var context = {};
    let sql;
    let inserts;

    if (req.query.table == "users"){
        sql = "INSERT INTO users (`name`, `password`, `notifications`) VALUES (?, ?, ?)";
        inserts = [req.query.name, req.query.password, req.query.notifications];
    }

    else if (req.query.table == "materials"){
        sql = "INSERT INTO materials (`name`, `pro`) VALUES (?, ?)";
        inserts = [req.query.name, req.query.pro];
    }

    else if (req.query.table == "centers"){
        sql = "INSERT INTO centers(`name`, `street_number`, `street_direction`, `street_name`, `street_type`, `city`, `state`, `zip`) values(?, ?, ?, ?, ?, ?, ?, ?)";
        inserts = [req.query.name, req.query.street_number, req.query.street_direction, req.query.street_name, req.query.street_type, req.query.city, req.query.state, req.query.zip];
    }

    else if (req.query.table == "schedules"){
        sql = "INSERT INTO schedules (`day_of_week`, `time_open`, `time_closed`, `cid`) VALUES (?, ?, ?, ?)";
        inserts = [req.query.day_of_week, req.query.time_open, req.query.time_closed, req.query.cid];
    }

    else if (req.query.table == "handlingInstructions"){
        sql = "INSERT INTO handlingInstructions (`instructions`) VALUES (?)";
        inserts = [req.query.instructions];
    }

    else if (req.query.table == "disposalInstructions"){
        sql = "INSERT INTO disposalInstructions (`instructions`) VALUES (?)";
        inserts = [req.query.instructions];
    }


    pool.query(sql, inserts, function(err, result){
        if(err){
            next(err);
            return;
        }
        context.results = "Inserted id " + result.insertId;
        res.render('home',context);
    });
});

app.get('/delete',function(req,res,next){
    var context = {};
    sql= "DELETE FROM ?? WHERE id=?";
    inserts = [req.query.table, req.query.id];
    pool.query(sql, inserts, function(err, result){
        if(err){
            context.error = err;
            console.log("err: ", err);
            next(err);
            return;
        }
        context.results = "Deleted " + result.changedRows + " rows.";
        res.render('home',context);
    });
});


// safe-update?id=1&name=The+Task&purpose=false
app.get('/safe-update',function(req,res,next){
    var context = {};
    sql = "SELECT * FROM ?? WHERE id=?";
    inserts = [req.query.table, req.query.id];
    pool.query(sql, inserts, function(err, result){
        if(err){
            next(err);
            return;
        }
        if(result.length == 1){
            var curVals = result[0];

            if (req.query.table == "users"){
                sql = "UPDATE users SET name=?, password=?, notifications=? WHERE id=? ";
                inserts = [req.query.name || curVals.name, req.query.password || curVals.password, req.query.notifications || curVals.notifications, req.query.id];
            }

            else if (req.query.table == "materials"){
                sql = "UPDATE materials SET name=?, pro=?  WHERE id=? ";
                inserts = [req.query.name || curVals.name, req.query.pro || curVals.pro, req.query.id];
            }


            else if (req.query.table == "handlingInstructions"){
                sql = "UPDATE handlingInstructions SET instructions=?  WHERE id=? ";
                inserts = [req.query.instructions || curVals.instructions, req.query.id];
            }

            else if (req.query.table == "disposalInstructions"){
                sql = "UPDATE disposalInstructions SET instructions=?  WHERE id=? ";
                inserts = [req.query.instructions || curVals.instructions, req.query.id];
            }

            else if (req.query.table == "centers"){
                sql = "UPDATE centers SET name=?, street_number=?, street_direction=?, street_name=?, street_type=?, city=?, state=?, zip=? WHERE id=? ";
                inserts = [req.query.name || curVals.name, req.query.street_direction || curVals.street_direction, req.query.street_number || curVals.street_number,req.query.street_name || curVals.street_name, req.query.street_type || curVals.street_type,req.query.city || curVals.city, req.query.state || curVals.state, req.query.zip || curVals.zip, req.query.id];
            }

            else if (req.query.table == "schedules"){
                sql = "UPDATE schedules SET day_of_week=?, time_open=?, time_closed=?, cid=? WHERE id=? ";
                inserts = [req.query.day_of_week || curVals.day_of_week, req.query.time_open || curVals.time_open, req.query.time_closed || curVals.time_closed, req.query.cid || curVals.cid, req.query.id];
            }



            pool.query(sql, inserts, function(err, result){
                if(err){
                    next(err);
                    return;
                }
                context.results = "Updated " + result.changedRows + " rows.";
                res.render('home',context);
            });
        }
    });
});




app.get('/reset-table',function(req,res,next){
    var context = {};
    sql = `SOURCE program.sql`;
    pool.query(sql, function(err){
        if(err){
            next(err);
            return;
        }
        context.results = "Table reset";
        res.render('home',context);
    })
});

app.get('/edit-users', function(req,res,next) {
    var context = {};
    sql = 'SELECT * FROM users WHERE id=?';
    inserts = [req.query.id];
    pool.query(sql, inserts , function(err, rows, fields){
        if(err){
            next(err);
            return;
        }
        context.table = "users";
        context.users = rows;
        res.render('edit-users.handlebars', context);
    });
});


app.get('/edit-materials', function(req,res,next) {
    var context = {};
    sql = 'SELECT * FROM materials WHERE id=?';
    inserts = [req.query.id];
    pool.query(sql, inserts , function(err, rows, fields){
        if(err){
            next(err);
            return;
        }
        context.table = "materials";
        context.materials = rows;
        res.render('edit-materials.handlebars', context);
    });
});

app.get('/edit-centers', function(req,res,next) {
    var context = {};
    sql = 'SELECT * FROM centers WHERE id=?';
    inserts = [req.query.id];
    pool.query(sql, inserts , function(err, rows, fields){
        if(err){
            next(err);
            return;
        }
        context.table = "centers";
        context.centers = rows;
        res.render('edit-centers.handlebars', context);
    });
});


app.get('/edit-handlingInstructions', function(req,res,next) {
    var context = {};
    sql = 'SELECT * FROM handlingInstructions WHERE id=?';
    inserts = [req.query.id];
    pool.query(sql, inserts , function(err, rows, fields){
        if(err){
            next(err);
            return;
        }
        context.table = "handlingInstructions";
        context.handlingInstructions = rows;
        res.render('edit-handlingInstructions.handlebars', context);
    });
});


app.get('/edit-disposalInstructions', function(req,res,next) {
    var context = {};
    sql = 'SELECT * FROM disposalInstructions WHERE id=?';
    inserts = [req.query.id];
    pool.query(sql, inserts , function(err, rows, fields){
        if(err){
            next(err);
            return;
        }
        context.table = "disposalInstructions";
        context.disposalInstructions = rows;
        res.render('edit-disposalInstructions.handlebars', context);
    });
});


app.get('/edit-schedules', function(req,res,next) {
    var context = {};
    sql = `
    SELECT S.id, S.day_of_week, S.time_open, S.time_closed, C.name as centers,
        CASE
    WHEN S.day_of_week = 1 THEN "sunday"
    WHEN S.day_of_week = 2 THEN "monday"
    WHEN S.day_of_week = 3 THEN "tuesday"
    WHEN S.day_of_week = 4 THEN "wednesday"
    WHEN S.day_of_week = 5 THEN "thursday"
    WHEN S.day_of_week = 6 THEN "friday"
    WHEN S.day_of_week = 7 THEN "saturday"
    ELSE "invalid day number"
    END AS day_of_week
    FROM centers C INNER JOIN schedules S ON C.id = S.cid
    WHERE S.id=?`;
    inserts = [req.query.id];

    pool.query(sql, inserts , function(err, rows, fields){
        if(err){
            next(err);
            return;
        }
        context.table = "schedules";
        context.schedules = rows;

        sql = "SELECT * FROM centers";
        pool.query(sql, inserts , function(err, rows, fields){
            if(err){
                next(err);
                return;
            }

            context.centers = rows;
            res.render('edit-schedules.handlebars', context);
        });
    });
});





app.get('/er', function(req,res,next) {
    res.render('er.handlebars');
});

app.get('/schema', function(req,res,next) {
    res.render('schema.handlebars');
});

app.get('/docs', function(req,res,next) {
    res.render('docs.handlebars');
});

app.use(function(req,res){
    res.status(404);
    res.render('404');
});

app.use(function(err, req, res, next){
    console.error(err.stack);
    res.status(500);
    res.render('500');
});

app.listen(app.get('port'), function(){
    console.log('Express started on http://localhost:' + app.get('port') + '; press Ctrl-C to terminate.');
});

