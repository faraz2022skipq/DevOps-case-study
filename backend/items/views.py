from django.http import JsonResponse
from .models import Item

def item_list(request):
    items = list(Item.objects.values("id", "name", "description"))
    return JsonResponse({"items": items})
