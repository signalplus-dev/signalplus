import React, { PureComponent } from 'react';
import { Field } from 'redux-form';
import { ButtonToolbar, DropdownButton, MenuItem } from 'react-bootstrap';

class Dropdown extends PureComponent {
  constructor(props) {
    super(props);
    this.onCheck = this.onCheck.bind(this);
  }

  onCheck(e, checked) {
    this.props.input.onChange(checked);
  }

  render() {
    const {
      input,
      touched,
      valid,
      visited,
      active,
      meta,
      ...props,
    } = this.props;

    return (
      <div className='tz-dropdown'>
        <ButtonToolbar>
          <DropdownButton title="Select your Timezone" id="dropdown-size-medium">
            <MenuItem eventKey="1" value=''>Action</MenuItem>
            <MenuItem eventKey="2">Another action</MenuItem>
            <MenuItem eventKey="3">Something else here</MenuItem>
          </DropdownButton>
        </ButtonToolbar>
      </div>
    );
  }
}

export default function DecoratedDropdown(props) {
  return (
    <Field
      {...props}
      component={Dropdown}
    />
  );
}
