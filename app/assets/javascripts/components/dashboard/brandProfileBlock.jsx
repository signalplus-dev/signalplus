import React from 'react';
import { connect } from 'react-redux';
import _ from 'lodash';
import URL from 'url';
import Loader from 'components/loader';

function BrandProfileBlock({ brand }) {
  if (!brand.loaded) return <Loader textOnly />;
  const brandInfo = _.get(brand, 'data', {});
  const profileImageUrl = URL.parse(brandInfo.profile_image_url || '')
  const profileImageSrc = `//${profileImageUrl.host || ''}${profileImageUrl.path || ''}`

  return (
    <div className="brand-profile-block">
      <img className="brand-profile-img" src={profileImageSrc} alt="Brand profile image"/>
      <div className="brand-profile-name">
        <h3>{brandInfo.name}</h3>
        <p>{`@${brandInfo.user_name}`}</p>
      </div>
    </div>
  );
}

export default connect(state => ({
  brand: state.models.brand,
}))(BrandProfileBlock);
