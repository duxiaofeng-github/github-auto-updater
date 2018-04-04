import urllib2
import re

contents = urllib2.urlopen("https://cloud.tencent.com/document/product/267/7479").read()

m = re.search('<span class="hljs-string">"(.*?)"</span>', contents)

if m :
	print('https:' + m.group(1))
