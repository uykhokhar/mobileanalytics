import webapp2
import json
import logging
import datetime
from datetime import datetime, timedelta
from google.appengine.api import mail
import google.appengine.api.mail

from models import *

################################################################################
class PostHandler(webapp2.RequestHandler):
    def post(self):

        json_string = self.request.body
        json_object = json.loads(json_string)
        logging.info("JSON STRING: "+json_string)
        logging.info(json_object)
        self.response.out.write(json_string)
        self.process(json_string=json_string)

    def get(self):
        self.response.out.write("Hello Chicken {}".format(datetime.now().time()))


    def process(self, json_string):
        print("************** PARSING**************")
        data = json.loads(json_string)
        session_data = data["session"]

        session_obj = Session(user=session_data["user"])

        touches_data = session_data["touches"]
        for touch in touches_data:
            x_data = float(touch["x"])
            y_data = float(touch["y"])
            touch_obj = Touch(x=x_data, y=y_data)
            touch_key = touch_obj.put()
            session_obj.touches.append(touch_key)
            session_obj.put()

        events_data = session_data["events"]
        for event in events_data:
            event_name = event["id"]
            event_obj = Event(name = event_name)
            event_key = event_obj.put()
            session_obj.events.append(event_key)

        #parse dates
        session_obj.start = datetime.strptime(session_data["start"], '%Y-%m-%d %H:%M:%S +0000')
        session_obj.end = datetime.strptime(session_data["end"], '%Y-%m-%d %H:%M:%S +0000')
        session_obj.put()

        logging.info(session_obj)




#for testing email sending, not required for production, email sends sucessfully
class EmailHandler(webapp2.RequestHandler):

    def get(self, daily_unique, monthly_unique, daily_sessions, avg_length):
        mail.send_mail(sender='anything@analytics-165115.appspotmail.com',
                       to="Umar <ukhokhar@uchicago.edu>",
                       subject="Activity summary",
                       body="""Here is your daily summary for your application:
*Daily active uses: {}
*Monthly active users: {}
*Daily sessions: {}
*Average session length: {} seconds
Have a great evening!
        """.format(daily_unique, monthly_unique, daily_sessions, avg_length))

        self.response.out.write("Message Sent {}".format(datetime.now().time()))



class CronHandler(webapp2.RequestHandler):

    #create message
    def get(self):
        daily_unique = Session.query_daily_unique()
        monthly_unique = Session.query_30day_unique()
        daily_sessions = Session.daily_sessions()
        avg_length = Session.avg_session_length()

        mail.send_mail(sender='anything@analytics-165115.appspotmail.com',
                       to="Umar <ukhokhar@uchicago.edu>",
                       subject="Activity summary",
                       body="""Here is your daily summary for your application:
        *Daily active uses: {}
        *Monthly active users: {}
        *Daily sessions: {}
        *Average session length: {} seconds
        Have a great evening!
                """.format(daily_unique, monthly_unique, daily_sessions, avg_length))



app = webapp2.WSGIApplication([
    ('/', PostHandler),
    webapp2.Route('/summary/', handler=CronHandler),
    webapp2.Route('/email/<daily_unique>/<monthly_unique>/<daily_sessions>/<avg_length>/', handler=EmailHandler)
    ],
    debug=True)
