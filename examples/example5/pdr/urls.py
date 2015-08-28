from django.conf.urls import patterns, include, url
from django.conf.urls.static import static
from django.conf.urls import include, url
from django.contrib.staticfiles.urls import staticfiles_urlpatterns
from pdr.settings import MEDIA_ROOT, MEDIA_URL


urlpatterns = [
    url(r'^$', 'pdr.views.home', name='home'),
] + static(MEDIA_URL, document_root=MEDIA_ROOT)

urlpatterns += staticfiles_urlpatterns()
