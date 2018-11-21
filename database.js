// setup express and handlebars
var express = require('express');
var mysql = require('./dbcon.js');

var app = express();
var handlebars = require('express-handlebars').create({defaultLayout:'main'});

app.engine('handlebars', handlebars.engine);
app.set('view engine', 'handlebars');

// set port number to command line argument
app.set('port', process.argv[2]);

app.use(express.static('public'));

// home page (GET request)
app.get('/search',function(req,res,next){
    var context = {};
    // select name, purpose, url, version, license FROM program P inner join program_src PS ON PS.pid = P.id inner join src S on PS.sid = S.id;
    /*
      sql = `SELECT * FROM program WHERE (program.name LIKE "%"?"%");
      SELECT * FROM author WHERE (author.name LIKE "%"?"%");
      SELECT * FROM language WHERE (language.name LIKE "%"?"%");
      SELECT * FROM os WHERE (os.name LIKE "%"?"%");
      SELECT * FROM src WHERE (src.url LIKE "%"?"%");`
    */

    var sql = `SELECT * FROM users WHERE (users.name LIKE "%"?"%")`;
    inserts = [req.query.search, req.query.search];

    mysql.pool.query(sql,inserts, function(err, rows, fields){
        if(err){
            next(err);
            return;
        }
        //console.log("rows: " + JSON.stringify(rows));
        context.users = rows; //JSON.stringify(rows);
        //console.log("rows: " + context.users);

        sql = `SELECT * FROM materials WHERE (materials.name LIKE "%"?"%")`;
        inserts = [req.query.search];

        mysql.pool.query(sql,inserts, function(err, rows, fields){
            if(err){
                next(err);
                return;
            }
            context.materials = rows; //JSON.stringify(rows);

            sql = `SELECT * FROM centers WHERE (centers.name LIKE "%"?"%")`;
            inserts = [req.query.search];

            mysql.pool.query(sql,inserts, function(err, rows, fields){
                if(err){
                    next(err);
                    return;
                }
                context.centers = rows; //JSON.stringify(rows);


                    sql = `SELECT * FROM schedules WHERE (schedules.day_of_week LIKE "%"?"%")`;
                    inserts = [req.query.search];

                    mysql.pool.query(sql,inserts, function(err, rows, fields){
                        if(err){
                            next(err);
                            return;
                        }
                        context.schedules = rows; //JSON.stringify(rows);


                        sql = `SELECT DISTINCT C.id AS cid, U.id AS uid, C.name AS cname, U.name AS uname FROM users_centers UC INNER JOIN users U ON UC.cid = U.id INNER JOIN centers C ON UC.cid = C.id WHERE (U.name LIKE "%"?"%") OR (C.name LIKE "%"?"%")`;
                        inserts = [req.query.search, req.query.search];

                        mysql.pool.query(sql,inserts, function(err, rows, fields){
                            if(err){
                                next(err);
                                return;
                            }
                            context.users_centers = rows; //JSON.stringify(rows);


                            //console.log("myresults: " + JSON.stringify(context));
                            res.render('search', context);
                        });
                    });
            });
        });
    });
});


// home page (GET request)
app.get('/search-materials',function(req,res,next){
    var context = {};
    context.layout = false;
    // select name, purpose, url, version, license FROM program P inner join program_src PS ON PS.pid = P.id inner join src S on PS.sid = S.id;
    /*
      sql = `SELECT * FROM program WHERE (program.name LIKE "%"?"%");
      SELECT * FROM author WHERE (author.name LIKE "%"?"%");
      SELECT * FROM language WHERE (language.name LIKE "%"?"%");
      SELECT * FROM os WHERE (os.name LIKE "%"?"%");
      SELECT * FROM src WHERE (src.url LIKE "%"?"%");`
    */

    sql = `SELECT * FROM materials WHERE (materials.name LIKE "%"?"%")`;
    inserts = [req.query.search];

    mysql.pool.query(sql,inserts, function(err, rows, fields){
        if(err){
            next(err);
            return;
        }
        context.materials = rows; //JSON.stringify(rows);

        sql = `SELECT * FROM materials WHERE (materials.name LIKE "%"?"%")`;
        inserts = [req.query.search];

        mysql.pool.query(sql,inserts, function(err, rows, fields){
            if(err){
                next(err);
                return;
            }
            context.materials = rows; //JSON.stringify(rows);
            res.render('search-materials', context);
        });
    });
});


// home page (GET request)
app.get('/search-handling',function(req,res,next){
    var context = {};
    context.layout = false;

    sql = `SELECT H.instructions FROM materials_handling MH 
    INNER JOIN materials M ON M.id = MH.mid
    INNER JOIN handlingInstructions H ON H.id = MH.HID
    WHERE (M.name = ?)`;

    inserts = [req.query.search];

    mysql.pool.query(sql,inserts, function(err, rows, fields){
        if(err){
            next(err);
            return;
        }
        context.instructions = rows; //JSON.stringify(rows);
        res.render('search-handling', context);
    });
});

// home page (GET request)
app.get('/search-centers',function(req,res,next){
    var context = {};
    context.layout = false;

    sql = `SELECT C.name, C.street_number, C.street_direction, C.street_name, C.street_type, C.city, C.state, C.zip FROM centers_materials CM
    INNER JOIN centers C ON C.id = CM.CID
    INNER JOIN materials M ON M.id = CM.MID
    WHERE (M.name = ?);`;

    inserts = [req.query.search];

    mysql.pool.query(sql,inserts, function(err, rows, fields){
        if(err){
            next(err);
            return;
        }
        context.centers = rows; //JSON.stringify(rows);
        res.render('search-centers', context);
    });
});

// home page (GET request)
app.get('/users',function(req,res,next){
    var context = {};
    // select name, purpose, url, version, license FROM program P inner join program_src PS ON PS.pid = P.id inner join src S on PS.sid = S.id;
    sql = 'SELECT * FROM users';
    mysql.pool.query(sql, function(err, rows, fields){
        if(err){
            next(err);
            return;
        }
        context.users = rows;
        context.table = "users";
        res.render('users', context);
    });
});

// home page (GET request)
app.get('/materials',function(req,res,next){
    var context = {};
    // select name, purpose, url, version, license FROM program P inner join program_src PS ON PS.pid = P.id inner join src S on PS.sid = S.id;
    sql = 'SELECT * FROM materials';
    mysql.pool.query(sql, function(err, rows, fields){
        if(err){
            next(err);
            return;
        }
        context.materials = rows;
        context.table = "materials";
        res.render('materials', context);
    });
});


// home page (GET request)
app.get('/handlingInstructions',function(req,res,next){
    var context = {};
    // select name, purpose, url, version, license FROM program P inner join program_src PS ON PS.pid = P.id inner join src S on PS.sid = S.id;
    sql = 'SELECT * FROM handlingInstructions';
    mysql.pool.query(sql, function(err, rows, fields){
        if(err){
            next(err);
            return;
        }
        context.handlingInstructions = rows;
        context.table = "handlingInstructions";
        res.render('handlingInstructions', context);
    });
});


// home page (GET request)
app.get('/disposalInstructions',function(req,res,next){
    var context = {};
    // select name, purpose, url, version, license FROM program P inner join program_src PS ON PS.pid = P.id inner join src S on PS.sid = S.id;
    sql = 'SELECT * FROM disposalInstructions';
    mysql.pool.query(sql, function(err, rows, fields){
        if(err){
            next(err);
            return;
        }
        context.disposalInstructions = rows;
        context.table = "disposalInstructions";
        res.render('disposalInstructions', context);
    });
});

// home page (GET request)
app.get('/centers',function(req,res,next){
    var context = {};
    // select name, purpose, url, version, license FROM program P inner join program_src PS ON PS.pid = P.id inner join src S on PS.sid = S.id;
    sql = 'SELECT * FROM centers';
    mysql.pool.query(sql, function(err, rows, fields){
        if(err){
            next(err);
            return;
        }
        context.centers = rows;
        context.table = "centers";
        res.render('centers', context);
    });
});



// home page (GET request)
app.get('/schedules',function(req,res,next){
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
            FROM centers C INNER JOIN schedules S ON C.id = S.cid`;


    //sql = 'SELECT * FROM schedules';
    mysql.pool.query(sql, function(err, rows, fields){
        if(err){
            next(err);
            return;
        }

        context.table = "schedules";
        context.schedules = rows;

        sql = 'SELECT * FROM centers';
        mysql.pool.query(sql, function(err, rows, fields){
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
app.get('/program-author',function(req,res,next){
    var context = {};
    // select name, purpose, url, version, license FROM program P inner join program_src PS ON PS.pid = P.id inner join src S on PS.sid = S.id;
    sql = 'SELECT A.id AS aid, P.id AS pid, A.name AS aname, P.name AS pname FROM program_author PA INNER JOIN program P ON PA.pid = P.id INNER JOIN author A ON PA.aid = A.id';
    mysql.pool.query(sql, function(err, rows, fields){
        if(err){
            next(err);
            return;
        }
        context.program_author = rows;

        sql = 'SELECT * FROM program';
        mysql.pool.query(sql, function(err, rows, fields){
            if(err){
                next(err);
                return;
            }
            context.program = rows;


            sql = 'SELECT * FROM author';
            mysql.pool.query(sql, function(err, rows, fields){
                if(err){
                    next(err);
                    return;
                }
                context.author = rows;

                context.table = "program_author";
                res.render('program-author', context);
            });
        });
    });
});



// home page (GET request)
app.get('/',function(req,res,next){
    var context = {};
    sql = 'SELECT COUNT(*) AS num FROM users';
    mysql.pool.query(sql, function(err, rows, fields){
        if(err){
            next(err);
            return;
        }
        context.users = rows;

        sql = 'SELECT COUNT(*) AS num FROM materials';
        mysql.pool.query(sql, function(err, rows, fields){
            if(err){
                next(err);
                return;
            }
            context.materials = rows;

            sql = 'SELECT COUNT(*) AS num FROM handlingInstructions';
            mysql.pool.query(sql, function(err, rows, fields){
                if(err){
                    next(err);
                    return;
                }
                context.handlingInstructions = rows;

                sql = 'SELECT COUNT(*) AS num FROM disposalInstructions';
                mysql.pool.query(sql, function(err, rows, fields){
                    if(err){
                        next(err);
                        return;
                    }
                    context.disposalInstructions = rows;

                    sql = 'SELECT COUNT(*) AS num FROM centers';
                    mysql.pool.query(sql, function(err, rows, fields){
                        if(err){
                            next(err);
                            return;
                        }
                        context.centers = rows;

                        sql = 'SELECT COUNT(*) AS num FROM schedules';
                        mysql.pool.query(sql, function(err, rows, fields){
                            if(err){
                                next(err);
                                return;
                            }
                            context.schedules = rows;
                            res.render('home', context);
                        });
                    });
                });
            });
        });
    });
});

// home page (GET request)
app.get('/',function(req,res,next){
    var context = {};
    // select name, purpose, url, version, license FROM program P inner join program_src PS ON PS.pid = P.id inner join src S on PS.sid = S.id;
    sql = 'SELECT * FROM users';
    mysql.pool.query(sql, function(err, rows, fields){
        if(err){
            next(err);
            return;
        }
        context.users = rows;

        sql = 'SELECT * FROM materials';
        mysql.pool.query(sql, function(err, rows, fields){
            if(err){
                next(err);
                return;
            }
            context.materials = rows;

            sql = 'SELECT * FROM centers';
            mysql.pool.query(sql, function(err, rows, fields){
                if(err){
                    next(err);
                    return;
                }
                context.centers = rows;

                sql = 'SELECT * FROM hazards';
                mysql.pool.query(sql, function(err, rows, fields){
                    if(err){
                        next(err);
                        return;
                    }
                    context.hazards = rows;

                    res.render('home', context);
                });
            });
        });
    });
});


// home page (POST request)
app.post('/',function(req,res,next){
    var context = {};
    sql = 'SELECT * FROM program';
    mysql.pool.query(sql, function(err, rows, fields){
        if(err){
            next(err);
            return;
        }
        context.results = JSON.stringify(rows);
        res.render('home', context);
    });
});

app.get('/update',function(req,res,next){
    var context = {};
    sql = 'SELECT * FROM program';
    mysql.pool.query(sql, function(err, rows, fields){
        if(err){
            next(err);
            return;
        }
        context.results = JSON.stringify(rows);
        res.send(context.results);
    });
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


    mysql.pool.query(sql, inserts, function(err, result){
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
    console.log("sql: " + sql);
    console.log("inserts: " + inserts);
    mysql.pool.query(sql, inserts, function(err, result){
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


///simple-update?id=2&name=The+Task&purpose=false&version=2015-12-5
app.get('/simple-update',function(req,res,next){
    var context = {};
    sql = "UPDATE program SET name=?, purpose=?, url=?, version=?, license=? WHERE id=? ";
    inserts = [req.query.name, req.query.purpose, req.query.url, req.query.version, req.query.license, req.query.id];
    mysql.pool.query(sql, inserts, function(err, result){
        if(err){
            next(err);
            return;
        }
        context.results = "Updated " + result.changedRows + " rows.";
        res.render('home',context);
    });
});


///safe-update?id=1&name=The+Task&purpose=false
app.get('/safe-update',function(req,res,next){
    var context = {};
    sql = "SELECT * FROM ?? WHERE id=?";
    inserts = [req.query.table, req.query.id];
    mysql.pool.query(sql, inserts, function(err, result){
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



            mysql.pool.query(sql, inserts, function(err, result){
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



///safe-update?id=1&name=The+Task&purpose=false
app.get('/safe-update-pl',function(req,res,next){
    var context = {};
    sql = "SELECT * FROM ?? WHERE pid=? AND lid=?";
    inserts = [req.query.table, req.query.pid, req.query.lid];
    mysql.pool.query(sql, inserts, function(err, result){
        if(err){
            next(err);
            return;
        }
        if(result.length == 1){
            var curVals = result[0];

            sql = "UPDATE program_language SET pid=?, lid=? WHERE pid=? AND lid=?";
            inserts = [req.query.pidnew || curVals.pidnew, req.query.lidnew || curVals.lid, req.query.pid || curVals.pid, req.query.lid || curVals.lidreq.query.id];
            console.log("update query.pid: ", req.query.pid);
            console.log("update query.lid: ", req.query.lid);

            console.log("update query.pidnew: ", req.query.pidnew);
            console.log("update query.lidnew: ", req.query.lidnew);



            mysql.pool.query(sql, inserts, function(err, result){
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
    mysql.pool.query(sql, function(err){
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
    mysql.pool.query(sql, inserts , function(err, rows, fields){
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
    mysql.pool.query(sql, inserts , function(err, rows, fields){
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
    mysql.pool.query(sql, inserts , function(err, rows, fields){
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
    mysql.pool.query(sql, inserts , function(err, rows, fields){
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
    mysql.pool.query(sql, inserts , function(err, rows, fields){
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

    mysql.pool.query(sql, inserts , function(err, rows, fields){
        if(err){
            next(err);
            return;
        }
        context.table = "schedules";
        context.schedules = rows;

        sql = "SELECT * FROM centers";
        mysql.pool.query(sql, inserts , function(err, rows, fields){
            if(err){
                next(err);
                return;
            }

            context.centers = rows;
            res.render('edit-schedules.handlebars', context);
        });
    });
});


app.get('/edit-program-author', function(req,res,next) {
    var context = {};
    sql = 'SELECT A.id AS aid, P.id AS pid, A.name AS aname, P.name AS pname FROM program_author PA INNER JOIN program P ON PA.pid = P.id INNER JOIN author A ON PA.aid = A.id WHERE P.id = ? AND A.id = ?';
    //sql = 'SELECT * FROM program_language WHERE pid=? AND lid=?';
    inserts = [req.query.pid, req.query.aid];
    mysql.pool.query(sql, inserts , function(err, rows, fields){
        if(err){
            next(err);
            return;
        }
        context.program_author = rows;


        sql = 'SELECT * FROM program';
        mysql.pool.query(sql, function(err, rows, fields){
            if(err){
                next(err);
                return;
            }
            context.program = rows;


            sql = 'SELECT * FROM author';
            mysql.pool.query(sql, function(err, rows, fields){
                if(err){
                    next(err);
                    return;
                }
                context.author = rows;

                context.table = "program_author";
                res.render('edit-program-author.handlebars', context);
            });
        });
    });
});


app.get('/edit-os', function(req,res,next) {
    var context = {};
    sql = 'SELECT * FROM os WHERE id=?';
    inserts = [req.query.id];
    mysql.pool.query(sql, inserts , function(err, rows, fields){
        if(err){
            next(err);
            return;
        }
        context.table = "os";
        context.os = rows;
        res.render('edit-os.handlebars', context);
    });
});


app.get('/edit-src', function(req,res,next) {
    var context = {};

    sql = 'SELECT S.id, S.url, S.type, S.pid, P.name FROM src S INNER JOIN program P on S.pid = P.id WHERE S.id = ?;';
    inserts = [req.query.id];
    mysql.pool.query(sql, inserts, function(err, rows, fields){
        if(err){
            next(err);
            return;
        }
        context.src = rows;

        sql = 'SELECT * FROM program';
        mysql.pool.query(sql, function(err, rows, fields){
            if(err){
                next(err);
                return;
            }
            context.program = rows;
            //context.results = JSON.stringify(rows);
            context.table = "src";
            res.render('edit-src', context);
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

