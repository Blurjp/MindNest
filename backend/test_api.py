"""
Simple test script to verify the MindNest API is working

Run this after starting the backend server:
    python test_api.py
"""

import requests
import json

BASE_URL = "http://localhost:8000"

def test_health_check():
    """Test the root endpoint"""
    print("\n1. Testing health check...")
    response = requests.get(f"{BASE_URL}/")
    print(f"Status: {response.status_code}")
    print(f"Response: {json.dumps(response.json(), indent=2)}")
    assert response.status_code == 200


def test_emotion_detection():
    """Test emotion detection"""
    print("\n2. Testing emotion detection...")
    payload = {
        "text": "I feel really anxious and worried about tomorrow"
    }
    response = requests.post(
        f"{BASE_URL}/api/emotion",
        json=payload
    )
    print(f"Status: {response.status_code}")
    data = response.json()
    print(f"Response: {json.dumps(data, indent=2)}")
    assert response.status_code == 200
    assert "emotion" in data
    print(f"✓ Detected emotion: {data['emotion']}")


def test_meditation_generation():
    """Test meditation generation"""
    print("\n3. Testing meditation generation...")
    payload = {
        "emotion": "anxious",
        "duration_minutes": 5,
        "voice_style": "female"
    }
    response = requests.post(
        f"{BASE_URL}/api/meditate",
        json=payload
    )
    print(f"Status: {response.status_code}")
    data = response.json()
    print(f"Generated text preview: {data['text'][:100]}...")
    print(f"Audio URL: {data['audio_url']}")
    print(f"Duration: {data['duration_seconds']} seconds")
    assert response.status_code == 200
    print(f"✓ Meditation generated successfully")


def test_journal_logging():
    """Test journal entry logging"""
    print("\n4. Testing journal logging...")
    payload = {
        "emotion_before": "anxious",
        "emotion_after": "calm",
        "session_type": "meditation"
    }
    response = requests.post(
        f"{BASE_URL}/api/journal",
        json=payload
    )
    print(f"Status: {response.status_code}")
    data = response.json()
    print(f"Response: {json.dumps(data, indent=2)}")
    assert response.status_code == 200
    print(f"✓ Journal entry logged with ID: {data['entry_id']}")


def test_journal_retrieval():
    """Test retrieving journal entries"""
    print("\n5. Testing journal retrieval...")
    response = requests.get(f"{BASE_URL}/api/journal?limit=5")
    print(f"Status: {response.status_code}")
    data = response.json()
    print(f"Retrieved {len(data)} entries")
    if data:
        print(f"Latest entry: {json.dumps(data[0], indent=2)}")
    assert response.status_code == 200
    print(f"✓ Journal entries retrieved")


def test_sleep_routines():
    """Test sleep routines endpoint"""
    print("\n6. Testing sleep routines...")
    response = requests.get(f"{BASE_URL}/api/routines")
    print(f"Status: {response.status_code}")
    data = response.json()
    print(f"Available routines: {len(data['routines'])}")
    for routine in data['routines']:
        print(f"  - {routine['emoji']} {routine['name']} ({routine['duration_min']} min)")
    assert response.status_code == 200
    print(f"✓ Sleep routines retrieved")


def run_all_tests():
    """Run all API tests"""
    print("=" * 60)
    print("MindNest API Test Suite")
    print("=" * 60)

    try:
        test_health_check()
        test_emotion_detection()
        test_meditation_generation()
        test_journal_logging()
        test_journal_retrieval()
        test_sleep_routines()

        print("\n" + "=" * 60)
        print("✓ All tests passed!")
        print("=" * 60)

    except requests.exceptions.ConnectionError:
        print("\n✗ Error: Could not connect to API")
        print("Make sure the backend is running:")
        print("  cd backend && python app/main.py")
    except AssertionError as e:
        print(f"\n✗ Test failed: {e}")
    except Exception as e:
        print(f"\n✗ Unexpected error: {e}")


if __name__ == "__main__":
    run_all_tests()
