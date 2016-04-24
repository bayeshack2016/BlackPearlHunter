from django.shortcuts import render
from django.shortcuts import render
from django.http import HttpResponse
from django.shortcuts import render_to_response
from django.template import RequestContext
from django.views.decorators.csrf import csrf_protect


# Create your views here.

def index(request):
    return render_to_response('index.html',context_instance=RequestContext(request))
