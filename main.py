import webapp2
import json
import logging

################################################################################
class PostHandler(webapp2.RequestHandler):
    def post(self):
        json_string = self.request.body
        json_object = json.loads(json_string)
        logging.info("JSON STRING: "+json_string)
        logging.info(json_object)
        self.response.out.write(json_string)


app = webapp2.WSGIApplication([
    ('/', PostHandler)
    ],
    debug=True)
