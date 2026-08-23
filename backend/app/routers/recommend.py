from fastapi import APIRouter, Depends

from app.schemas import RecommendRequest, RecommendResponse
from app.services.recommender import RecommenderService, get_recommender_service

router = APIRouter()


@router.post("/recommend", response_model=RecommendResponse)
def recommend(
    payload: RecommendRequest,
    service: RecommenderService = Depends(get_recommender_service),
) -> RecommendResponse:
    return service.recommend(payload)


@router.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok"}