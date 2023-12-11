class ReplyService {
    static add(reply, callback, error) {
        console.log("add reply ...");
        $.ajax({
            type : 'post',
            url : '/replies/new',
            data : JSON.stringify(reply),
            contentType : "application/json; charset=utf-8",
            success : function(result, status, xhr) {
                if(callback) {
                    callback(status);
                }
            },
            error : function(xhr, status, er) {
                if(error) {
                    error(xhr.status + '' + status);
                }
            }
        });
    }
    static getList(param, callback, error) {
    	let bno = param.bno;
    	$.getJSON("/replies/pages/"+bno, function(data) {
            if(callback) {
                console.log(data);
                callback(data);
            }
        }).fail(function(xhr, status, err) {
            if(error) {
                error(xhr.status + ' ' + status);
            }
        });
    }
    static displyTime(timeValue) {
        let today = new Date();
        let gap = today.getTime()-timeValue;
        let dateObj = new Date(timeValue);
        let str="";
        if(gap < (1000 * 60 * 60 * 24)) {
            let hh = dateObj.getHours();
            let mi = dateObj.getMinutes();
            let ss = dateObj.getSeconds();
            return [ (hh>9 ? '': '0') + hh, ':', (mi >9 ? '':'0') +mi, ':', (ss>9 ? '' : '0')+ss].join('');
        } else {
            let yy = dateObj.getFullYear();
            let mm = dateObj.getMonth() + 1; //getMonth is zero-based
            let dd = dateObj.getDate();
            return [ yy, '/', (mm>9 ? '':'0') + mm, '/', (dd>9 ? '':'0')+dd].join('');
        }
    }
    
    static displyTime2(timeValue) {
        let today = new Date();
        let gap = today.getTime()-timeValue;
        let dateObj = new Date(timeValue);
       
        let yy = dateObj.getFullYear();
        let mm = dateObj.getMonth() + 1; //getMonth is zero-based
        let dd = dateObj.getDate();
        return [ yy, '/', (mm>9 ? '':'0') + mm, '/', (dd>9 ? '':'0')+dd].join('');
        
    }
    
    static get(rno, callback, error) {
        $.get("/replies/" + rno, function(result) {
            if(callback) {
            	console.log(result);
                callback(result);
            }
        }).fail(function(xhr, status, err) {
            if(error) {
                error();
            }
        });
    }
    static update(reply, callback, error) {
        console.log("update");
        $.ajax({
            type : 'patch',
            url : '/replies/' + reply.rno,
            data : JSON.stringify(reply),
            contentType : "application/json; charset=utf-8",
            success: function(updateResult, status, xhr) {
                if(callback) {
                    callback(updateResult);
                }
            },error : function(xhr, status, er) {
                if(error) {
                    error(er);
                }
            }
        });
    }
    static remove(rno, callback, error) {
        console.log("remove");
        $.ajax({
            type : 'delete',
            url : '/replies/' + rno,
            success: function(deleteResult, status, xhr) {
                if(callback) {
                    callback(deleteResult);
                }
            },error : function(xhr, status, er) {
                if(error) {
                    error(er);
                }
            }
        });
    }
    static getListWithPaging(param, callback, error) {
        let bno = param.bno;
        let page = param.page;

        $.getJSON("/replies/pages/"+ bno + "/" + page, function(data) {
                if(callback) {
                    console.log(data.replyCnt, data.list);
                    callback(data.replyCnt, data.list);
                }
        }).fail(function(xhr, status, err) {
                if(error) {
                    error(xhr.status + ' ' + status);
                }
        });
    }
}