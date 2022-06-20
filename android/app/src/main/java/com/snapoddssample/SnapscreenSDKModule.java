package com.snapoddssample;

import android.annotation.SuppressLint;
import android.app.AlertDialog;
import android.content.Intent;
import android.graphics.Color;
import android.os.Handler;
import android.os.Looper;

import androidx.annotation.NonNull;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.LifecycleEventListener;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeArray;
import com.snapscreen.mobile.Environment;
import com.snapscreen.mobile.Snapscreen;
import com.snapscreen.mobile.model.snap.SportEventSnapResultEntry;
import com.snapscreen.mobile.snap.SnapActivity;
import com.snapscreen.mobile.snap.SnapActivityInitializationListener;
import com.snapscreen.mobile.snap.SnapActivityResultListener;
import com.snapscreen.mobile.snap.SnapConfiguration;
import com.snapscreen.mobile.snap.SnapFragment;
import com.squareup.moshi.Moshi;

public class SnapscreenSDKModule extends ReactContextBaseJavaModule implements SnapActivityInitializationListener, SnapActivityResultListener, LifecycleEventListener {

    SnapscreenSDKModule(ReactApplicationContext context) {
        super(context);

        context.addLifecycleEventListener(this);
    }

    private String snapTitle = "";

    @NonNull
    @Override
    public String getName() {
        return "SnapscreenSDKModule";
    }

    @ReactMethod public void testNativeModule() {
        new AlertDialog.Builder(getCurrentActivity())
                .setTitle("Welcome to SnapOdds")
                .setMessage("The Native SDK Module integration is working")
                .setPositiveButton("OK", (dialog, which) -> {})
                .setCancelable(true)
                .create()
                .show();
    }

    @ReactMethod public void setupWithClientId(String clientId, String secret) {
        Snapscreen.Companion.setup(getReactApplicationContext(), clientId, secret, Environment.PRODUCTION);

    }

    @ReactMethod public void setupForTestEnvironmentWithClientId(String clientId, String secret) {
        Snapscreen.Companion.setup(getReactApplicationContext(), clientId, secret, Environment.TEST);
    }

    @ReactMethod public void setCountry(String country) {
        Snapscreen.Companion.getInstance().setCountry(country);

    }

    @ReactMethod public void setUsState(String usState) {
        Snapscreen.Companion.getInstance().setUsState(usState);
    }

    @ReactMethod public void presentSportMediaFlowWithConfiguration(ReadableMap parameters) {
        SnapConfiguration snapConfiguration = new SnapConfiguration();

        if (parameters.hasKey("automaticSnap")) {
            snapConfiguration.setAutomaticSnap(parameters.getBoolean("automaticSnap"));
        }
        if (parameters.hasKey("autosnapTimeoutDuration")) {
            snapConfiguration.setAutoSnapTimeoutDuration(parameters.getDouble("autosnapTimeoutDuration"));
        }
        if (parameters.hasKey("autosnapIntervalInSeconds")) {
            snapConfiguration.setAutoSnapIntervalInSeconds(parameters.getDouble("autosnapIntervalInSeconds"));
        }
        if (parameters.hasKey("title")) {
            snapTitle = parameters.getString("title");
        }

        Intent snapIntent = SnapActivity.Companion.intentForSportsMedia(getCurrentActivity(), snapConfiguration, false, this);
        getCurrentActivity().startActivity(snapIntent);
    }

    private Callback latestCallback = null;

    @ReactMethod public void presentOperatorFlowWithConfiguration(ReadableMap parameters, Callback callback) {
        SnapConfiguration snapConfiguration = new SnapConfiguration();

        if (parameters.hasKey("automaticSnap")) {
            snapConfiguration.setAutomaticSnap(parameters.getBoolean("automaticSnap"));
        }
        if (parameters.hasKey("autosnapTimeoutDuration")) {
            snapConfiguration.setAutoSnapTimeoutDuration(parameters.getDouble("autosnapTimeoutDuration"));
        }
        if (parameters.hasKey("autosnapIntervalInSeconds")) {
            snapConfiguration.setAutoSnapIntervalInSeconds(parameters.getDouble("autosnapIntervalInSeconds"));
        }
        if (parameters.hasKey("title")) {
            snapTitle = parameters.getString("title");
        }

        Intent snapIntent = SnapActivity.Companion.intentForSportsOperator(getCurrentActivity(), snapConfiguration, this, this);
        getCurrentActivity().startActivity(snapIntent);
        latestCallback = callback;
    }

    @ReactMethod public void updateSnapUIConfiguration(ReadableMap parameters) {
        Handler mainHandler = new Handler(Looper.getMainLooper());
        mainHandler.post(() -> {
            if (parameters.hasKey("hideDefaultViewFinderAndQuadrangleDetection")) {
                Snapscreen.Companion.getInstance().getSnapUiConfiguration().setHideDefaultViewFinderAndQuadrangleDetection(parameters.getBoolean("hideDefaultViewFinderAndQuadrangleDetection"));
            }
            if (parameters.hasKey("snapHintText")) {
                Snapscreen.Companion.getInstance().getSnapUiConfiguration().setSnapHintText(parameters.getString("snapHintText"));
            }
            if (parameters.hasKey("snapProgressText")) {
                Snapscreen.Companion.getInstance().getSnapUiConfiguration().setSnapProgressText(parameters.getString("snapProgressText"));
            }
            if (parameters.hasKey("snapErrorGeneralText")) {
                Snapscreen.Companion.getInstance().getSnapUiConfiguration().setSnapErrorGeneralText(parameters.getString("snapErrorGeneralText"));
            }
            if (parameters.hasKey("snapErrorConnectionIssueText")) {
                Snapscreen.Companion.getInstance().getSnapUiConfiguration().setSnapErrorConnectionIssueText(parameters.getString("snapErrorConnectionIssueText"));
            }
            if (parameters.hasKey("snapErrorNoResultsText")) {
                Snapscreen.Companion.getInstance().getSnapUiConfiguration().setSnapErrorNoResultsText(parameters.getString("snapErrorNoResultsText"));
            }
            if (parameters.hasKey("hidePoweredBySnapOddsBranding")) {
                Snapscreen.Companion.getInstance().getSnapUiConfiguration().setHidePoweredBySnapOddsBranding(parameters.getBoolean("hidePoweredBySnapOddsBranding"));
            }
        });
    }

    @ReactMethod public void updateOddsUIConfiguration(ReadableMap parameters) {
        Handler mainHandler = new Handler(Looper.getMainLooper());
        mainHandler.post(() -> {
            if (parameters.hasKey("title")) {
                Snapscreen.Companion.getInstance().getOddsUiConfiguration().setTitle(parameters.getString("title"));
            }
            if (parameters.hasKey("loadingText")) {
                Snapscreen.Companion.getInstance().getOddsUiConfiguration().setLoadingText(parameters.getString("loadingText"));
            }
            if (parameters.hasKey("errorText")) {
                Snapscreen.Companion.getInstance().getOddsUiConfiguration().setErrorText(parameters.getString("errorText"));
            }
            if (parameters.hasKey("tryAgainText")) {
                Snapscreen.Companion.getInstance().getOddsUiConfiguration().setTryAgainText(parameters.getString("tryAgainText"));
            }
            if (parameters.hasKey("moneyTitle")) {
                Snapscreen.Companion.getInstance().getOddsUiConfiguration().setMoneyTitle(parameters.getString("moneyTitle"));
            }
            if (parameters.hasKey("spreadTitle")) {
                Snapscreen.Companion.getInstance().getOddsUiConfiguration().setSpreadTitle(parameters.getString("spreadTitle"));
            }
            if (parameters.hasKey("totalTitle")) {
                Snapscreen.Companion.getInstance().getOddsUiConfiguration().setTotalTitle(parameters.getString("totalTitle"));
            }
            if (parameters.hasKey("bestOddsTitle")) {
                Snapscreen.Companion.getInstance().getOddsUiConfiguration().setBestOddsTitle(parameters.getString("bestOddsTitle"));
            }
            if (parameters.hasKey("hidePoweredBySnapOddsBranding")) {
                Snapscreen.Companion.getInstance().getOddsUiConfiguration().setHidePoweredBySnapOddsBranding(parameters.getBoolean("hidePoweredBySnapOddsBranding"));
            }
        });
    }

    @SuppressLint("ResourceType")
    @ReactMethod public void updateColorConfiguration(ReadableMap parameters) {
        Handler mainHandler = new Handler(Looper.getMainLooper());
        mainHandler.post(() -> {
            if (parameters.hasKey("textPrimary")) {
                Snapscreen.Companion.getInstance().getColorConfiguration().setTextPrimary(Color.parseColor(parameters.getString("textPrimary")));
            }
            if (parameters.hasKey("textAccent")) {
                Snapscreen.Companion.getInstance().getColorConfiguration().setTextAccent(Color.parseColor(parameters.getString("textAccent")));
            }
            if (parameters.hasKey("backgroundWhite")) {
                Snapscreen.Companion.getInstance().getColorConfiguration().setBackgroundWhite(Color.parseColor(parameters.getString("backgroundWhite")));
            }
            if (parameters.hasKey("background")) {
                Snapscreen.Companion.getInstance().getColorConfiguration().setBackground(Color.parseColor(parameters.getString("background")));
            }
            if (parameters.hasKey("backgroundMuted")) {
                Snapscreen.Companion.getInstance().getColorConfiguration().setBackgroundMuted(Color.parseColor(parameters.getString("backgroundMuted")));
            }
            if (parameters.hasKey("border")) {
                Snapscreen.Companion.getInstance().getColorConfiguration().setBorder(Color.parseColor(parameters.getString("border")));
            }
            if (parameters.hasKey("backgroundAccent")) {
                Snapscreen.Companion.getInstance().getColorConfiguration().setBackgroundAccent(Color.parseColor(parameters.getString("backgroundAccent")));
            }
            if (parameters.hasKey("backgroundAccentShade")) {
                Snapscreen.Companion.getInstance().getColorConfiguration().setBackgroundAccentShade(Color.parseColor(parameters.getString("backgroundAccentShade")));
            }
            if (parameters.hasKey("error")) {
                Snapscreen.Companion.getInstance().getColorConfiguration().setError(Color.parseColor(parameters.getString("error")));
            }
            if (parameters.hasKey("errorShade")) {
                Snapscreen.Companion.getInstance().getColorConfiguration().setErrorShade(Color.parseColor(parameters.getString("errorShade")));
            }
        });
    }

    @Override
    public void onSnapActivityCreate(@NonNull SnapActivity snapActivity) {
        snapActivity.setTitle(snapTitle);
    }

    @Override
    public void snapActivityDidSnapSportEvent(@NonNull SnapActivity snapActivity, @NonNull SnapFragment snapFragment, @NonNull SportEventSnapResultEntry sportEventSnapResultEntry) {
        snapActivity.finish();

        if (latestCallback != null) {
            String json = new Moshi.Builder().build().adapter(SportEventSnapResultEntry.class).toJson(sportEventSnapResultEntry);

            WritableMap map = Arguments.createMap();
            map.putString("externalId", sportEventSnapResultEntry.getSportEvent().getExternalId());
            map.putString("snapResultEntry", json);

            latestCallback.invoke(map);
        }
        latestCallback = null;
    }

    @Override
    public void onHostResume() {
        latestCallback = null;
    }

    @Override
    public void onHostPause() {
    }

    @Override
    public void onHostDestroy() {
    }
}
