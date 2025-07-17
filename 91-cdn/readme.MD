## CDN (Cloudfront)
Here CDN is used to reduce the latency while fetching the data from diff regions
if there is application hosted in for suppose US Region and if anyone need to access that data from india region it will take more time to travel the data from US Region to India Region and it will increase latency. in order to reduce that we are using cloudfront this will store the data in nearest edge locations so from there we will get the details
So First time when user access the application it will take the data from wherever app is hosted and this first time it will store the data in edge locations and from next time whenever user accessing it it will take from that edge location so it is nothing but edge location acts as a cache
Here CDN is used to store only static content like images,videos and it is not applicable for dynamic contents
if there is any change in application and the application is redeployed it once again then we should use invalidate this will again store the latest data in cache/edge location
and cache policy is set to wait for 24 hours after that it will take new data again

## origin 
from cloudfront --> frontend_alb --> frontend --> backend_alb --> backend
so here origin is load balancer which is frontend_alb
origin_id : this is frontend_alb origin_id and the frontend_alb dns name we kept in route53 so we are taking that route53 of frontend_alb
domain_name: we can give cdn.pavithra.fun - cdn.domainname and in the browser we will hit with this URL

under default_cache_behavior  --> disabling the cache policy by keeping cachedisabled and taking this cache policy from aws using data source
under ordered_cache_behavior giving the path in order to enable the cache policy by keeping cacheEnabled and taking this cache policy from aws using data source

storing the cdn record in route53 bcoz cdn is also act as a load balancer so giving the domain_name and hosted_zone while adding the record in route53

